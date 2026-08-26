import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct TargetsUseXCConfigRuleTests {
	@Test
	func targetsWithoutXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try TargetsUseXCConfigRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func targetsWithOnlyXCConfigs() throws {
		let url = try Bundle.module.testDataURL(named: "TargetsUseXCConfigFiles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try TargetsUseXCConfigRule().run(env)

		#expect(violations.isEmpty)
	}
}
