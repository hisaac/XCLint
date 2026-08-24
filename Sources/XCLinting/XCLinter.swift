import Foundation
import XcodeProj

public struct XCLinter {
	public struct Environment {
		public let project: XcodeProj
		public let projectRootURL: URL
		public let configuration: Configuration

		public init(project: XcodeProj, projectRootURL: URL, configuration: Configuration) {
			self.project = project
			self.projectRootURL = projectRootURL
			self.configuration = configuration
		}
	}

	public typealias Rule = @Sendable (Environment) throws -> [Violation]

	public var environment: Environment
	public var rules: [Rule]

	public init(projectPath: String, configuration: Configuration) throws {
		let env = try Environment(projectPath: projectPath, configuration: configuration)

		try self.init(environment: env)
	}

	public init(environment: Environment) throws {
		let config = environment.configuration
		let enabledRules = config.enabledRules

		let rules = Self.ruleMap.filter({ enabledRules.contains($0.key) }).values

		self.init(environment: environment, rules: Array(rules))
	}

	public init(environment: Environment, rules: [Rule]) {
		self.environment = environment
		self.rules = rules
	}

	public func run() throws -> [Violation] {
		var violations = [Violation]()
		for rule in rules {
			let results = try rule(environment)

			violations.append(contentsOf: results)
		}
		return violations
	}
}

extension XCLinter.Environment {
	public init(projectPath: String, configuration: Configuration) throws {
		guard !projectPath.isEmpty else {
			throw XCLintError.noProjectFileSpecified
		}

		let url = URL(fileURLWithPath: projectPath)
		let xcodeproj = try XcodeProj(pathString: projectPath)

		self.init(project: xcodeproj, projectRootURL: url, configuration: configuration)
	}
}

extension XCLinter {
	public static let defaultRuleIdentifiers: Set<String> = [
		"build_files_ordered",
		"validate_build_settings",
		"relative_paths",
	]

	public static let defaultRules: [Rule] = Array(ruleMap.filter({ defaultRuleIdentifiers.contains($0.0) }).values)
	public static let ruleIdentifiers: Set<String> = Set(ruleMap.keys)

	public static let ruleMap: [String: Rule] = [
		"embedded_build_setting": { try EmbeddedBuildSettingsRule().run($0) },
		"build_files_ordered": { try BuildFilesAreOrderedRule().run($0) },
		"groups_sorted": { try GroupsAreSortedRule().run($0) },
		"validate_build_settings": { try ValidateBuildSettingsRule().run($0) },
		"implicit_dependencies": { try ImplicitDependenciesRule().run($0) },
		"targets_use_xcconfig": { try TargetsUseXCConfigRule().run($0) },
		"projects_use_xcconfig": { try ProjectsUseXCConfigRule().run($0) },
		"shared_scheme_skips_tests": { try SharedSchemeSkipsTestsRule().run($0) },
		"relative_paths": { try RelativePathsRule().run($0) },
		"shared_schemes": { try SharedSchemesRule().run($0) },
	]
}
