import Foundation
import XcodeProj

struct GroupsAreSortedRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()
		for group in environment.project.pbxproj.groups {
			violations.append(contentsOf: validateGroupIsSorted(group))
		}
		return violations
	}

	private func validateGroupIsSorted(_ group: PBXGroup) -> [Violation] {
		var violations = [Violation]()

		// a path can contain components, but only the last component without the extension matters from the UI's perspective
		let children = group.children
			.compactMap(\.path)
			.compactMap { $0.split(separator: "/").last }
			.compactMap { $0.split(separator: ".").first }

		let sortedChildren = children.sorted { lhs, rhs in
			lhs.compare(
				rhs,
				options: [
					.numeric,
					.caseInsensitive,
					.widthInsensitive,
					.forcedOrdering
				],
				locale: .current
			) == .orderedAscending
		}

		// some groups have no path, like the auto-generated "Products".
		// Let's skip those, as they appear to not even always show up in the UI.
		if children != sortedChildren, let path = group.path {
			violations.append(.init("Group \"\(path)\" contains unsorted children"))
		}

		for childGroup in group.children.compactMap({ $0 as? PBXGroup }) {
			violations.append(contentsOf: validateGroupIsSorted(childGroup))
		}

		return violations
	}
}
