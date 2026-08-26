import Foundation

public struct Configuration: Hashable {
	public var disabledRules: Set<String>
	public var optInRules: Set<String>
	public var rules: [String: RuleConfiguration]

	public init(
		rules: [String: RuleConfiguration] = [:],
		disabledRules: Set<String> = Set(),
		optInRules: Set<String> = Set()
	) {
		self.rules = rules
		self.disabledRules = disabledRules
		self.optInRules = optInRules
	}
}

extension Configuration {
	public enum RuleConfiguration: Codable {
		case warning
		case error

		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()

			if let value = try? container.decode(String.self) {
				switch value {
				case "warning":
					self = .warning
					return
				case "error":
					self = .error
					return
				default:
					break
				}
			}

			throw DecodingError.dataCorrupted(
				.init(
					codingPath: decoder.codingPath,
					debugDescription: "failed to decode rule configuration object"
				)
			)
		}
	}
}

extension Configuration: Decodable {
	enum CodingKeys: CodingKey {
		/// Contains all the top-level well-defined keys used in a configuration file
		enum PredefinedKeys: String {
			case disabledRules = "disabled_rules"
			case optInRules = "opt_in_rules"
		}

		case disabledRules
		case optInRules
		case ruleIdentifier(String)

		init?(intValue: Int) {
			return nil
		}

		init?(stringValue: String) {
			switch stringValue {
			case PredefinedKeys.disabledRules.rawValue:
				self = .disabledRules
			case PredefinedKeys.optInRules.rawValue:
				self = .optInRules
			default:
				self = .ruleIdentifier(stringValue)
			}
		}

		var stringValue: String {
			switch self {
			case .disabledRules:
				PredefinedKeys.disabledRules.rawValue
			case .optInRules:
				PredefinedKeys.optInRules.rawValue
			case let .ruleIdentifier(value):
				value
			}
		}

		var intValue: Int? {
			return nil
		}
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.disabledRules = Set()
		self.optInRules = Set()

		var decodedRules = [String: RuleConfiguration]()

		for key in container.allKeys {
			switch key {
			case .disabledRules:
				self.disabledRules = try container.decode(Set<String>.self, forKey: key)
			case .optInRules:
				self.optInRules = try container.decode(Set<String>.self, forKey: key)
			case let .ruleIdentifier(name):
				let ruleConfig = try container.decode(RuleConfiguration.self, forKey: key)

				decodedRules[name] = ruleConfig
			}
		}

		self.rules = decodedRules
	}

	public func validate() throws {
		let allIdentifiers = XCLinter.ruleIdentifiers

		for id in disabledRules where allIdentifiers.contains(id) == false {
			throw XCLintError.unrecognizedRuleName(id)
		}

		for id in optInRules where allIdentifiers.contains(id) == false {
			throw XCLintError.unrecognizedRuleName(id)
		}
	}
}

extension Configuration {
	public var enabledRules: Set<String> {
		let defaultIdentifiers = XCLinter.defaultRuleIdentifiers

		return defaultIdentifiers
			.union(optInRules)
			.subtracting(disabledRules)
	}
}
