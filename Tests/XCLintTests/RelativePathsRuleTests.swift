import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct RelativePathsRuleTests {
	@Test
	func projectWithOnlyRelativePaths() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try RelativePathsRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithOneAbsoluteFilePath() throws {
		let url = try Bundle.module.testDataURL(named: "AbsoluteFileReference.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try RelativePathsRule().run(env)

		#expect(!violations.isEmpty)
	}
}
