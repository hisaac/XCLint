import Testing

@testable import XCLinting

@Suite
struct TargetsUseXCConfigRuleTests {
	@Test
	func targetsWithoutXCConfigs() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try TargetsUseXCConfigRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func targetsWithOnlyXCConfigs() throws {
		let env = try XCLinter.Environment.fixture(named: "TargetsUseXCConfigFiles.xcodeproj")

		let violations = try TargetsUseXCConfigRule().run(env)

		#expect(violations.isEmpty)
	}
}
