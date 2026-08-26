import Foundation

/// Detect projects that do not use XCConfigs.
struct ProjectsUseXCConfigRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		for project in environment.project.pbxproj.projects {
			let configs = project.buildConfigurationList?.buildConfigurations ?? []

			for config in configs where config.baseConfiguration?.path == nil {
				violations.append(.init("No xcconfig set for \(project.name), \(config.name)"))
			}
		}

		return violations
	}
}
