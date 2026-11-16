import Testing

@testable import XCLinting

@Suite
struct ValidateBuildSettingsRuleTests {
	@Test
	func projectWithNoInvalidBuildSettings() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try ValidateBuildSettingsRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithInvalidBuildSettings() throws {
		// This has ALWAYS_SEARCH_USER_PATHS set to YES at the project level
		let env = try XCLinter.Environment.fixture(named: "InvalidEmbeddedBuildSettings.xcodeproj")

		let violations = try ValidateBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func invalidSettingsInXCConfigFile() throws {
		let env = try XCLinter.Environment.fixture(named: "XCConfigFiles.xcodeproj")

		let violations = try ValidateBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}
}
