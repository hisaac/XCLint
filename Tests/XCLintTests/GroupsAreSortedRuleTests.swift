import Testing

@testable import XCLinting

@Suite
struct GroupsAreSortedRuleTests {
	@Test
	func projectWithGroupsSorted() throws {
		let env = try XCLinter.Environment.fixture(named: "SortedGroups.xcodeproj")

		let violations = try GroupsAreSortedRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func projectWithoutGroupsSorted() throws {
		let env = try XCLinter.Environment.fixture(named: "UnsortedGroups.xcodeproj")

		let violations = try GroupsAreSortedRule().run(env)

		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithoutGroupsSortedByReference() throws {
		let env = try XCLinter.Environment.fixture(named: "SortedGroupsByReference.xcodeproj")

		let violations = try GroupsAreSortedRule().run(env)

		#expect(violations.isEmpty)
	}

	@Test
	func groupSortedWhereExtensionsMatters() throws {
		let env = try XCLinter.Environment.fixture(named: "FileOrderedWithExtensions.xcodeproj")

		let violations = try GroupsAreSortedRule().run(env)

		#expect(violations.isEmpty)
	}
}
