import Testing

@testable import XCLinting

@Suite
struct SharedSchemeSkipsTestsRuleTests {
	@Test
	func projectWithNoSkippedTests() throws {
		let env = try XCLinter.Environment.fixture(named: "StockMacOSApp.xcodeproj")

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithSkippedTests() throws {
		let env = try XCLinter.Environment.fixture(named: "SchemeSkipsTests.xcodeproj")

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithSkippedTestBundles() throws {
		let env = try XCLinter.Environment.fixture(named: "SchemeSkipsTestBundles.xcodeproj")

		let violations = try SharedSchemeSkipsTestsRule().run(env)

		#expect(!violations.isEmpty)
	}
}
