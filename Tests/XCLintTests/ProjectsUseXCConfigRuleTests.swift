import XCTest

@testable import XCLinting
import XcodeProj

final class ProjectsUseXCConfigRuleTests: XCTestCase {
	func testProjectsWithoutXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ProjectsUseXCConfigRule().run(env)

		XCTAssertFalse(violations.isEmpty)
	}

	func testProjectsWithOnlyXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "ProjectsUseXCConfigFiles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ProjectsUseXCConfigRule().run(env)

		XCTAssertTrue(violations.isEmpty)
	}
}
