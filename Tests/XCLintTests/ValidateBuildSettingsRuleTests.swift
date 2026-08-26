import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct ValidateBuildSettingsRuleTests {
	@Test
	func projectWithNoInvalidBuildSettings() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ValidateBuildSettingsRule().run(env)

		#expect(violations == [])
	}

	@Test
	func projectWithInvalidBuildSettings() throws {
		// This has ALWAYS_SEARCH_USER_PATHS set to YES at the project level
		let url = try Bundle.module.testDataURL(named: "InvalidEmbeddedBuildSettings.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ValidateBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func invalidSettingsInXCConfigFile() throws {
		let url = try Bundle.module.testDataURL(named: "XCConfigFiles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ValidateBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}
}
