import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct ProjectsUseXCConfigRuleTests {
	@Test
	func projectsWithoutXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ProjectsUseXCConfigRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectsWithOnlyXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "ProjectsUseXCConfigFiles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ProjectsUseXCConfigRule().run(env)

		#expect(violations.isEmpty)
	}
}
