import Testing

@testable import XCLinting

@Suite
struct ImplicitDependenciesRuleTests {
	@Test
	func projectWithImplicitDependencies() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try ImplicitDependenciesRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithImplicitDependenciesDisabled() throws {
		let env = try XCLinter.Environment.fixture(named: "ImplicitDependenciesDisabled.xcodeproj")

		let violations = try ImplicitDependenciesRule().run(env)

		#expect(violations.isEmpty)
	}
}
