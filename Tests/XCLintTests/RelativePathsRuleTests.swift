import Testing

@testable import XCLinting

@Suite
struct RelativePathsRuleTests {
	@Test
	func projectWithOnlyRelativePaths() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try RelativePathsRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithOneAbsoluteFilePath() throws {
		let env = try XCLinter.Environment.fixture(named: "AbsoluteFileReference.xcodeproj")

		let violations = try RelativePathsRule().run(env)

		#expect(!violations.isEmpty)
	}
}
