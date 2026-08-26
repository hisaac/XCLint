# XCLint

Xcode project linting

Originally created by @mattmassicotte. Now maintained by @hisaac.

## Installation

XCLint is available as both a commandline tool and a library.

Tool:

```shell
brew tap hisaac/XCLint https://github.com/hisaac/XCLint.git
brew install xclint
```

This installs a prebuilt binary — a universal binary on macOS, a fully static one on Linux. To build from source off `main` instead, use `brew install --HEAD xclint` (requires a Swift 6.3+ toolchain).

Prebuilt binaries are also attached to every [release](https://github.com/hisaac/XCLint/releases) if you'd rather not use Homebrew.

Package:

```swift
dependencies: [
	.package(url: "https://github.com/hisaac/XCLint", branch: "main")
],
targets: [
	.testTarget(name: "MyTarget", dependencies: ["XCLinting"]),
]
```

## Tool Usage

Just run the `xclint` binary in your project directory. Check out its `-h` flag for more usage.

```shell
cd my/project
xclint
```

This will run a default set of rules. But, you can customize its behavior with a `.xclint.yml` file. The basic structure borrows a lot from [SwiftLint](https://github.com/realm/SwiftLint).

```yaml
# Some rules may not be appropriate for all projects. You must opt-in those.
opt_in_rules:
  - embedded_build_setting    # checks for build settings in the project file
  - groups_sorted             # checks that all group contents are alphabetically sorted
  - implicit_dependencies     # checks for any schemes that have "Find Implicit Dependencies" enabled
  - targets_use_xcconfig      # checks for any targets without a XCConfig file set
  - projects_use_xcconfig     # checks for any projects without a XCConfig file set
  - shared_scheme_skips_tests # checks for any shared schemes that have disabled tests
  - shared_schemes            # checks that all targets have a shared scheme present

# Other rules make sense for all projects by default. You must opt-out of those.
disabled_rules:
  - build_files_ordered       # checks that the ordering of techincally-unordered collections Xcode writes out is preserved
  - validate_build_settings   # checks that build settings have valid values
  - relative_paths            # checks for any absolute file references
```

## Alternatives

There are some similar projects out there, but none I've found are maintained any longer 😞

- [ProjLint](https://github.com/JamitLabs/ProjLint)
- [XcodeProjLint](https://github.com/RocketLaunchpad/XcodeProjLint)
- [xcprojectlint](https://github.com/americanexpress/xcprojectlint)

## Contributing and Collaboration

I welcome all suggestions, questions, and/or pull requests! Please don't hesitate to reach out or contribute.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
