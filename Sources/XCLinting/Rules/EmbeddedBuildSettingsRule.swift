import Foundation

import XcodeProj

struct EmbeddedBuildSettingsRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		// check top-level
		for project in environment.project.pbxproj.projects {
			let configs = project.buildConfigurationList?.buildConfigurations ?? []

			for config in configs where config.buildSettings.isEmpty == false {
				violations.append(.init("found settings for project \(project.name), \(config.name)"))
			}
		}

		// check targets
		environment.project.pbxproj.enumerateBuildConfigurations { name, configList in
			for config in configList.buildConfigurations where config.buildSettings.isEmpty == false {
				violations.append(.init("found settings for target \(name), \(config.name)"))
			}
		}

		return violations
	}
}
