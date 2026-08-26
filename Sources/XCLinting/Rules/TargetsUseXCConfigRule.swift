import Foundation

import XcodeProj
import XCConfig

/// Detect targets that do not use XCConfigs.
struct TargetsUseXCConfigRule {
	func run(_ environment: XCLinter.Environment) throws -> [Violation] {
		var violations = [Violation]()

		// check targets
		environment.project.pbxproj.enumerateBuildConfigurations { name, configList in
			for config in configList.buildConfigurations where config.baseConfiguration?.path == nil {
				violations.append(.init("No xcconfig set for \(name), \(config.name)"))
			}
		}

		return violations
	}
}
