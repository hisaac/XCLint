import Foundation
import Testing

import XCLinting

@Suite
struct ConfigurationTests {
	@Test
	func readEmptyFile() throws {
		let string = "{}"

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		#expect(config == Configuration())
	}

	@Test
	func readDisabledRules() throws {
		let string = """
{
	"disabled_rules": ["a", "b", "c"]
}
"""

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		let expected = Configuration(disabledRules: Set(["a", "b", "c"]))

		#expect(config == expected)
	}

	@Test
	func readOptInRules() throws {
		let string = """
{
	"opt_in_rules": ["a", "b", "c"]
}
"""

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		let expected = Configuration(optInRules: Set(["a", "b", "c"]))

		#expect(config == expected)
	}

	@Test
	func readRules() throws {
		let string = """
{
	"rule1": "warning",
	"rule2": "error",
}
"""

		let config = try JSONDecoder().decode(Configuration.self, from: Data(string.utf8))

		let expected = Configuration(rules: [
			"rule1": .warning,
			"rule2": .error
		])

		#expect(config == expected)
	}
}
