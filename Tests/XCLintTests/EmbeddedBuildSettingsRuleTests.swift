import Testing

@testable import XCLinting

@Suite
struct EmbeddedBuildSettingsRuleTests {
	@Test
	func projectWithBuildSettings() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try EmbeddedBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithProjectLevelBuildSettingsOnly() throws {
		let env = try XCLinter.Environment.fixture(named: "ProjectOnlyBuildSettings.xcodeproj")

		let violations = try EmbeddedBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithBuildSettingsRemoved() throws {
		let env = try XCLinter.Environment.fixture(named: "BuildSettingsRemoved.xcodeproj")

		let violations = try EmbeddedBuildSettingsRule().run(env)

		#expect(violations.isEmpty)
	}
}
