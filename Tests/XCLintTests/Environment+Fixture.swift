import Foundation
import Testing
import XCLinting
import XcodeProj

extension XCLinter.Environment {
	/// Loads a fixture project from `TestData` and wraps it in an environment with a default configuration.
	///
	/// As in the CLI, `projectRootURL` is the `.xcodeproj` bundle itself, not its containing directory.
	static func fixture(named name: String) throws -> XCLinter.Environment {
		let url = try Bundle.module.testDataURL(named: name)

		return XCLinter.Environment(
			project: try XcodeProj(pathString: url.path),
			projectRootURL: url,
			configuration: Configuration()
		)
	}
}
