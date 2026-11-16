import Testing
import XCLinting

@Suite
struct XCLinterTests {
	@Test
	func emptyProjectPathThrowsError() throws {
		let error = try #require(throws: XCLintError.self) {
			_ = try XCLinter(projectPath: "", configuration: Configuration())
		}

		guard case .noProjectFileSpecified = error else {
			Issue.record("wrong error: \(error)")
			return
		}
	}

	@Test
	func missingProjectFileThrowsError() {
		#expect(throws: (any Error).self) {
			_ = try XCLinter(projectPath: "/dev/null", configuration: Configuration())
		}
	}
}
