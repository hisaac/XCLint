import Foundation

/// Detect projects that do not use XCConfigs.
struct ProjectsUseXCConfigRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		for project in environment.project.pbxproj.projects {
			for config in project.buildConfigurationList?.buildConfigurations ?? [] {
				if config.baseConfiguration?.path == nil {
					violations.append(.init("No xcconfig set for \(project.name), \(config.name)"))
				}
			}
		}

		return violations
	}
}
