# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Toolchain and commands

`mise` manages both the toolchain and the task runner. Run `mise run bootstrap` (alias `up`) once to install tools, install git hooks, and resolve packages. Tasks:

| Task | Alias | Runs |
| --- | --- | --- |
| `mise run build` | `b` | `swift build` |
| `mise run test` | `t` | `swift test` |
| `mise run run` | `r`, `xclint` | `swift run xclint` |
| `mise run check` | `lint`, `chk` | `hk check --all` |
| `mise run package` | | universal macOS binary + tarball into `.release/` |
| `mise run fix` | `format` | `hk fix --all` |
| `mise run update` | `upd` | upgrade tools, refresh hk import pins, `swift package update` |
| `mise run clean` / `nuke` | | `swift package clean`/`reset`, then `purge-cache` |

Run a single test with an XCTest filter, e.g. `swift test --filter GroupsAreSortedRuleTests/testProjectWithoutGroupsSorted`, or a whole case with `swift test --filter GroupsAreSortedRuleTests`.

CI (`.github/workflows/ci.yml`) runs `mise run test` on `macos-latest`, plus a `zizmor` job that lints the workflows. This project is macOS-only: there is no Linux build, test, or release artifact.

## Linting and formatting

`hk` drives lint/format via `hk.pkl`. Its first two lines pin the hk package URL to the installed hk version and are rewritten mechanically by `scripts/update-hk-import.bash` (`mise run update-hk-import`) — edit hk.pkl from line 3 down only. The `linters` mapping in `hk.pkl` drives the `check`, `fix`, and `pre-commit` hooks alike, so adding an entry there wires it into all three. `swiftlint` (config in `.swiftlint.yml`) runs over `**/*.swift`; note that `swiftlint lint` exits 0 on warning-severity violations, so only error-severity ones fail `mise run check`.

`.editorconfig` sets tabs for indentation everywhere except YAML (2 spaces). Swift sources use tabs.

## Architecture

One package produces two products: the `xclint` executable (target `cli`) and the `XCLinting` library. `cli` is deliberately thin — argument parsing, locating the `.xcodeproj` and `.xclint.yml`, YAML decoding, and printing violations. Everything that decides what counts as a violation lives in `XCLinting`, which is what the library consumers import.

### Rules

A rule is just `@Sendable (XCLinter.Environment) throws -> [Violation]`. Concrete rules are internal structs in `Sources/XCLinting/Rules/` exposing `run(_ environment:) throws -> [Violation]`; they are wrapped in closures and registered by snake_case identifier in `XCLinter.ruleMap` (`Sources/XCLinting/XCLinter.swift`). There is no auto-discovery — a new rule file does nothing until it is added to `ruleMap`.

`XCLinter.defaultRuleIdentifiers` is the opt-out set. Anything in `ruleMap` but not in that set is opt-in. The effective set is `Configuration.enabledRules` = defaults ∪ `opt_in_rules` − `disabled_rules`.

So adding a rule means: the rule struct, a `ruleMap` entry, a decision about whether it belongs in `defaultRuleIdentifiers`, a fixture-backed test, and a line in the README's config example (which is the user-facing rule list).

### Configuration

`Configuration` has a hand-written `Decodable` conformance (`ConfigurationFile.swift`). Its `CodingKeys` maps the two predefined keys `disabled_rules` / `opt_in_rules` and treats *every other* top-level key as a rule identifier whose value is a `RuleConfiguration` (`warning` or `error`). Unknown keys therefore never fail decoding; `Configuration.validate()` — called by the CLI before linting — is what rejects unrecognized names in the two predefined lists.

Note that per-rule severity is decoded into `Configuration.rules` but nothing currently reads it; `XCLinter` only consults `enabledRules`. `Violation` likewise carries no severity.

### Environment gotcha

`XCLinter.Environment.projectRootURL` is the URL of the `.xcodeproj` bundle itself, not its containing directory. Rules that need the source root (and the CLI when looking for `.xclint.yml`) call `.deletingLastPathComponent()` on it. Getting this wrong is the easiest way to break a path-sensitive rule.

## Tests

Tests are XCTest (not swift-testing) and fixture-driven. Each rule test loads a checked-in `.xcodeproj` from `Tests/XCLintTests/TestData/` via `Bundle.module.testDataURL(named:)`, builds an `XCLinter.Environment` directly, invokes the rule struct alone (bypassing `ruleMap` and configuration), and asserts violations are empty or non-empty. Fixtures are usually paired — a passing and a failing project per rule — and are copied as bundle resources by `.copy("TestData")` in `Package.swift`.

Testing a new rule generally means authoring a new fixture `.xcodeproj` (often just a hand-edited `project.pbxproj`) rather than writing more Swift.

## Versioning and packaging

`.version` at the repo root is the single source of truth. It is embedded into the binary via `.embedInCode("../../.version")` and read at runtime as `PackageResources._version` to feed ArgumentParser's `--version`; `Formula/xclint.rb` reads the same file for the Homebrew version. Bump the version by editing `.version` only.

`.github/workflows/release.yml` is `workflow_dispatch`-only. It runs `mise run package` and uploads the resulting tarball as a workflow artifact — nothing more. It does not tag, cut a GitHub release, or touch the formula; those are still manual. `Formula/xclint.rb` still builds from `main` at install time.

Two constraints are worth knowing before touching `scripts/package.bash`:

- `swift build --arch arm64 --arch x86_64` does **not** work on this package: multi-arch routes through the Xcode build system, which does not generate the `PackageResources` accessor that `.embedInCode` needs. The script builds each slice separately and `lipo`s them.
- The macOS runner must be `macos-26` or newer. The `macos-15` image tops out at Xcode 26.3 / Swift 6.2.3, which cannot parse this package's `swift-tools-version: 6.3` (Xcode 26.4 was the first with Swift 6.3).

**macOS-only, deliberately.** No Linux build, test, or artifact. If you are ever tempted to add one back, know what blocks it: the Swift Static Linux SDK (musl) fails because PathKit, pulled in by XcodeProj, does `#if os(Linux) import Glibc` — `os(Linux)` is true under musl, but musl's platform module is named `Musl`, so it takes a branch that cannot compile. PathKit 1.0.1 is its latest release and XcodeProj 9.16.0 still depends on it. The glibc fallback (`-static-stdlib`) does build, but links `libicuuc.so.74` and glibc dynamically, pinning it to Ubuntu 24.04-era distros at 58 MB against macOS's 5.7 MB. The real unblock is an upstream PathKit PR using `#if canImport(Glibc)` / `#elseif canImport(Musl)`.

## hk

- Ask the hk MCP server to inspect the project and plan checks before execution.
- Scope work to changed files (`--files0-from` accepts exact NUL-delimited paths) and use `--cd` for another project root.
- Prefer safe checks and safe fixes. Inspect command effects and ask before any unknown or destructive command.
- Read normalized diagnostics from structured results, then inspect the patch before reporting or committing a fix.
- If MCP is unavailable, run `hk run check --format jsonl --safe`; the final event is the authoritative summary.
