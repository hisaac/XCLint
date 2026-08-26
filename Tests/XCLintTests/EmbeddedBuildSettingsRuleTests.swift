import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct EmbeddedBuildSettingsRuleTests {
	@Test
	func projectWithBuildSettings() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try EmbeddedBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithProjectLevelBuildSettingsOnly() throws {
		let url = try Bundle.module.testDataURL(named: "ProjectOnlyBuildSettings.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try EmbeddedBuildSettingsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithBuildSettingsRemoved() throws {
		let url = try Bundle.module.testDataURL(named: "BuildSettingsRemoved.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try EmbeddedBuildSettingsRule().run(env)

		#expect(violations.isEmpty)
	}
}
