import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct SharedSchemeSkipsTestsRuleTests {
	@Test
	func projectWithNoSkippedTests() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithSkippedTests() throws {
		let url = try Bundle.module.testDataURL(named: "SchemeSkipsTests.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithSkippedTestBundles() throws {
		let url = try Bundle.module.testDataURL(named: "SchemeSkipsTestBundles.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		#expect(!violations.isEmpty)
	}
}
