import XCTest
import XCLinting

final class XCLinterTests: XCTestCase {

	func testEmptyProjectPathThrowsError() throws {
		do {
			_ = try XCLinter(projectPath: "", configuration: Configuration())
			XCTFail()
		} catch XCLintError.noProjectFileSpecified {
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}


	func testMissingProjectFileThrowsError() throws {
		do {
			_ = try XCLinter(projectPath: "/dev/null", configuration: Configuration())
			XCTFail()
		} catch {
		}
	}
}
