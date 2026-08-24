import XCTest

@testable import XCLinting
import XcodeProj

final class GroupsAreSortedRuleTests: XCTestCase {
	func testProjectWithGroupsSorted() throws {
		let url = try Bundle.module.testDataURL(named: "SortedGroups.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		XCTAssertTrue(violations.isEmpty)
	}

	func testProjectWithoutGroupsSorted() throws {
		let url = try Bundle.module.testDataURL(named: "UnsortedGroups.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		XCTAssertFalse(violations.isEmpty)
	}

	func testProjectWithoutGroupsSortedByReference() throws {
		let url = try Bundle.module.testDataURL(named: "SortedGroupsByReference.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		XCTAssertTrue(violations.isEmpty)
	}

	func testGroupSortedWhereExtensionsMatters() throws {
		let url = try Bundle.module.testDataURL(named: "FileOrderedWithExtensions.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		XCTAssertTrue(violations.isEmpty)
	}
}
