import Testing

@testable import XCLinting

@Suite
struct BuildFilesAreOrderedTests {
	@Test
	func projectWithOrderedFiles() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try BuildFilesAreOrderedRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithOutOfOrderFiles() throws {
		let env = try XCLinter.Environment.fixture(named: "BuildFilesOutOfOrder.xcodeproj")

		let violations = try BuildFilesAreOrderedRule().run(env)

		#expect(!violations.isEmpty)
	}
}
