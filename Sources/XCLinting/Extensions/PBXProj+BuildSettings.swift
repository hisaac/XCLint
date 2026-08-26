import Foundation

import XCConfig
import XcodeProj

extension Parser {
	func parse(contentsOf url: URL) throws -> [Statement] {
		let string = try String(contentsOf: url)

		return parse(string)
	}
}

extension PBXProj {
	func enumerateBuildConfigurations(_ block: (String, XCConfigurationList) throws -> Void) rethrows {
		for target in legacyTargets {
			guard let list = target.buildConfigurationList else { continue }

			try block(target.name, list)
		}

		for target in nativeTargets {
			guard let list = target.buildConfigurationList else { continue }

			try block(target.name, list)
		}
	}

	func enumerateTargets(_ block: (PBXProject, PBXTarget) throws -> Void) rethrows {
		for proj in projects {
			for target in proj.targets {
				try block(proj, target)
			}
		}
	}

	func enumerateBuildSettingStatements(
		rootURL: URL,
		_ block: (PBXProject, PBXTarget, XCBuildConfiguration, [BuildSetting: String]) throws -> Void
	) throws {
		let sourceRootPath = rootURL.path

		for proj in projects {
			let projConfigList = proj.buildConfigurationList

			for target in proj.targets {
				for config in target.buildConfigurationList?.buildConfigurations ?? [] {
					let projConfig = projConfigList?.configuration(name: config.name)
					let projConfigURL = try projConfig?.baseConfigurationURL(with: sourceRootPath)
					let configURL = try config.baseConfigurationURL(with: sourceRootPath)

					let heirarchy = BuildSettingsHeirarchy(
						projectRootURL: rootURL,
						platformDefaults: [],
						projectConfigURL: projConfigURL,
						project: projConfig?.buildSettingsAssignments ?? [],
						configURL: configURL,
						target: config.buildSettingsAssignments
					)

					let settings: [BuildSetting: String]

					do {
						settings = try Evaluator().evaluate(heirarchy)
					} catch {
						print("XCConfig failed to evaluate settings heirarchy:", error)
						settings = [:]
					}

					try block(proj, target, config, settings)
				}
			}
		}
	}
}
