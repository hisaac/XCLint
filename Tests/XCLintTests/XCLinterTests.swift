import XCTest
import XCLinting

final class XCLinterTests: XCTestCase {

	func testEmptyProjectPathThrowsError() throws {
		do {
			_ = try XCLinter(projectPath: "", configuration: Configuration())
			XCTFail("expected XCLintError.noProjectFileSpecified for an empty project path")
		} catch XCLintError.noProjectFileSpecified {
		} catch {
			XCTFail("wrong error: \(error)")
		}
	}

	func testMissingProjectFileThrowsError() throws {
		do {
			_ = try XCLinter(projectPath: "/dev/null", configuration: Configuration())
			XCTFail("expected an error for a project path that is not an Xcode project")
		} catch {
		}
	}
}
