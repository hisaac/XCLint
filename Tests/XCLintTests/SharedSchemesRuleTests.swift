import Testing

@testable import XCLinting

@Suite
struct SharedSchemesRuleTests {
	@Test
	func projectWithSharedSchemes() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try SharedSchemesRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithMissingSharedSchemes() throws {
		let env = try XCLinter.Environment.fixture(named: "BuildFilesOutOfOrder.xcodeproj")

		let violations = try SharedSchemesRule().run(env)

		#expect(!violations.isEmpty)
	}
}
