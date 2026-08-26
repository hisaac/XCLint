import Foundation

struct BuildFilesAreOrderedRule {

	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		let projectText = try String(contentsOf: environment.projectRootURL.appendingPathComponent("project.pbxproj"))
		var violations = [Violation]()
		violations.append(contentsOf: try validateSection(forType: "PBXBuildFile", projectText: projectText))
		violations.append(contentsOf: try validateSection(forType: "PBXFileReference", projectText: projectText))
		return violations
	}

	private func validateSection(forType sectionType: String, projectText: String) throws -> [Violation] {
		// Find the range in projectText for the sectionType
		guard let range = getSectionRange(forType: sectionType, projectText: projectText) else {
			throw XCLintError.badProjectFile("Missing \(sectionType) section")
		}

		// split this range of projectText into lines. convert to String now to
		// avoid repeated conversions when applying the regex
		let lines = projectText[range].split(separator: "\n").map(String.init)

		// verify that there is more than one item in this section, otherwise no violations
		guard var previousLine = lines.first, lines.count > 1 else { return [] }
		guard var previousId = getId(from: previousLine) else { return [] }

		var violations = [Violation]()

		for line in lines.dropFirst() {
			guard let id = getId(from: line) else {
				continue
			}

			// compare the identifiers of this line with the previous line
			if verify(previousId, isLessThan: id) == false {
				guard
					let lineNote = violationNote(from: line),
					let previousLineNote = violationNote(from: previousLine)
				else {
					continue
				}

				violations.append(.init("\(sectionType) \(lineNote) is out of order with \(previousLineNote)."))
			}
			previousId = id
			previousLine = line
		}

		return violations
	}

	private func getSectionRange(forType sectionType: String, projectText: String) -> Range<String.Index>? {
		guard let start = projectText.range(of: "/* Begin \(sectionType) section */\n"),
			let end = projectText.range(of: "/* End \(sectionType) section */"),
			start.upperBound < end.lowerBound
		else { return nil }
		return start.upperBound..<end.lowerBound
	}

	// the pattern is a literal, so this can only fail if the pattern itself is malformed
	// swiftlint:disable:next force_try
	private let lineRegex = try! NSRegularExpression(pattern: #"^\s*([A-Z0-9]{24})\s+\/\*\s([^\*]*)\s\*\/"#, options: [])

	/// This function will find the `Substring` for the id of the PBXBuildFile or PBXFileReference
	private func getId(from line: String) -> Substring? {
		guard
			let match = lineRegex.firstMatch(in: line, options: [], range: line.nsrange),
			let idRange = Range(match.range(at: 1), in: line)
		else {
			print("BuildFilesAreOrderedRule failed to match on: ", line)

			return nil
		}
		return line[idRange]
	}

	private func getFileInfo(from line: String) -> Substring? {
		guard
			let match = lineRegex.firstMatch(in: line, options: [], range: line.nsrange),
			let infoRange = Range(match.range(at: 2), in: line)
		else {
			print("BuildFilesAreOrderedRule failed to match on: ", line)

			return nil
		}

		return line[infoRange]
	}

	private func violationNote(from line: String) -> String? {
		guard
			let id = getId(from: line),
			let info = getFileInfo(from: line)
		else {
			return nil
		}

		return "'(\(id)) \(info)'"
	}

	/// This function will compare two ids, passed in as Substrings, which should be the same length.
	/// Starting from the beginning of each substring, the first UTF8 character that is not exactly
	/// the same between the two ids is compared.
	private func verify(_ id1: Substring, isLessThan id2: Substring) -> Bool {
		guard let firstDifferingElement = zip(id1.utf8, id2.utf8).lazy.first(where: { $0.1 != $0.0 }) else { return false }
		return firstDifferingElement.0 < firstDifferingElement.1
	}
}

private extension String {
	var nsrange: NSRange { NSRange(startIndex..<endIndex, in: self) }
}
