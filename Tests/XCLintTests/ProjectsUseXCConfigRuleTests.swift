import Testing

@testable import XCLinting

@Suite
struct ProjectsUseXCConfigRuleTests {
	@Test
	func projectsWithoutXCConfigs() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try ProjectsUseXCConfigRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectsWithOnlyXCConfigs() throws {
		let env = try XCLinter.Environment.fixture(named: "ProjectsUseXCConfigFiles.xcodeproj")

		let violations = try ProjectsUseXCConfigRule().run(env)

		#expect(violations.isEmpty)
	}
}
