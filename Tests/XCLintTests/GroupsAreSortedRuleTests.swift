import Foundation
import Testing

@testable import XCLinting
import XcodeProj

@Suite
struct GroupsAreSortedRuleTests {
	@Test
	func projectWithGroupsSorted() throws {
		let url = try Bundle.module.testDataURL(named: "SortedGroups.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		#expect(violations.isEmpty)
	}

	@Test
	func projectWithoutGroupsSorted() throws {
		let url = try Bundle.module.testDataURL(named: "UnsortedGroups.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		#expect(!violations.isEmpty)
	}

	@Test
	func projectWithoutGroupsSortedByReference() throws {
		let url = try Bundle.module.testDataURL(named: "SortedGroupsByReference.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		#expect(violations.isEmpty)
	}

	@Test
	func groupSortedWhereExtensionsMatters() throws {
		let url = try Bundle.module.testDataURL(named: "FileOrderedWithExtensions.xcodeproj")

		let project = try XcodeProj(pathString: url.path)

		let env = XCLinter.Environment(
			project: project,
			projectRootURL: url,
			configuration: Configuration()
		)

		let violations = try GroupsAreSortedRule().run(env)
		#expect(violations.isEmpty)
	}
}
