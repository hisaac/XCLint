import XCTest

@testable import XCLinting
import XcodeProj

final class RelativePathsRuleTests: XCTestCase {
	func testProjectWithOnlyRelativePaths() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try RelativePathsRule().run(env)

		XCTAssertTrue(violations.isEmpty)
	}

	func testProjectWithOneAbosluteFilePath() throws {
		let url = try Bundle.module.testDataURL(named: "AbsolueFileReference.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try RelativePathsRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}
}
