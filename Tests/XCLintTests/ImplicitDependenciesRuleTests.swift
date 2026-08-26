import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct ImplicitDependenciesRuleTests {
	@Test
	func projectWithImplicitDependencies() throws {
		let url = try Bundle.module.testDataURL(named: "StockMacOSApp.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ImplicitDependenciesRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithImplicitDependenciesDisabled() throws {
		let url = try Bundle.module.testDataURL(named: "ImplicitDependenciesDisabled.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try ImplicitDependenciesRule().run(env)

		#expect(violations.isEmpty)
	}
}
