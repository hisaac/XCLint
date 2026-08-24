import Foundation

import XcodeProj
import XCConfig

/// Detect when a shared scheme has disabled tests.
struct SharedSchemeSkipsTestsRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		let sharedSchemesURL = environment
			.projectRootURL
			.appendingPathComponent("xcshareddata/xcschemes", isDirectory: true)
			.standardizedFileURL

		let fileManager = FileManager.default

		guard fileManager.isReadableFile(atPath: sharedSchemesURL.path) else { return [] }

		var violations = [Violation]()

		for entry in try fileManager.contentsOfDirectory(atPath: sharedSchemesURL.path) {
			let entryPath = sharedSchemesURL
				.appendingPathComponent(entry, isDirectory: false)
				.standardizedFileURL
				.path

			let scheme = try XCScheme(pathString: entryPath)

			guard let testAction = scheme.testAction else { continue }

			if testAction.testables.contains(where: { $0.skipped == true }) {
				violations.append(.init("Scheme \"\(entry)\" has skipped test bundles"))
			}

			if testAction.testables.contains(where: { $0.skippedTests.isEmpty == false }) {
				violations.append(.init("Scheme \"\(entry)\" has skipped tests"))
			}
		}


		return violations
	}

	private func validateSchemes(in url: URL) throws -> [Violation] {
		let fileManager = FileManager.default

		guard fileManager.isReadableFile(atPath: url.path) else { return [] }

		var violations = [Violation]()

		for entry in try fileManager.contentsOfDirectory(atPath: url.path) {
			let entryPath = url
				.appendingPathComponent(entry, isDirectory: false)
				.standardizedFileURL
				.path

			let scheme = try XCScheme(pathString: entryPath)

			if scheme.buildAction?.buildImplicitDependencies == true {
				violations.append(.init("Scheme \"\(entry)\" has implicit dependencies enabled"))
			}
		}

		return violations
	}
}
