import XCTest

@testable import XCLinting
import XcodeProj

final class BuildFilesAreOrderedTests: XCTestCase {
	func testProjectWithOrderedFiles() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let rules: [XCLinter.Rule] = [{ try BuildFilesAreOrderedRule().run($0) }]

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try rules.flatMap { try $0(env) }

		XCTAssertTrue(violations.isEmpty)
	}

	func testProjectWithOutOfOrderFiles() throws {
		let url = try Bundle.module.testDataURL(named: "BuildFilesOutOfOrder.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let rules: [XCLinter.Rule] = [{ try BuildFilesAreOrderedRule().run($0) }]

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try rules.flatMap { try $0(env) }

		XCTAssertFalse(violations.isEmpty)
	}
}
