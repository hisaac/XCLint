import Foundation
import ArgumentParser
import XcodeProj
import XCLinting
import Yams

@main
struct XCLintCommand: ParsableCommand {
	static let configuration = CommandConfiguration(commandName: "xclint")

	@Flag(
		name: .shortAndLong,
		help: "Print the version and exit."
	)
	var version: Bool = false

	@Argument(help: "The path to the .xcodeproj bundle to lint (defaults to looking in the current working directory).")
	var projectFile: String?

	@Option(
		name: .customLong("config"),
		help: "The path to an xclint configuration file (defaults to looking in the directory of the target .xcodeproj)."
	)
	var configFilePath: String?

	func run() throws {
		if version {
			throw CleanExit.message("0.1.5")
		}

		// find the xcodeproj file
		guard let projPath = resolvedProjectFilePath() else {
			throw XCLintError.noProjectFileSpecified
		}

		// find the effective environment
		let config = try resolvedConfiguration(projectRootURL: URL(fileURLWithPath: projPath))

		try config.validate()

		let env = try XCLinter.Environment(projectPath: projPath, configuration: config)

		let linter = try XCLinter(environment: env)

		let violations = try linter.run()

		for violation in violations {
			print(violation.message)
		}

		if !violations.isEmpty {
			throw ExitCode.failure
		}
	}
}

extension XCLintCommand {
	private func resolvedProjectFilePath() -> String? {
		if let path = projectFile {
			return path
		}

		let currentPath = FileManager.default.currentDirectoryPath

		guard let contents = try? FileManager.default.contentsOfDirectory(atPath: currentPath) else {
			return nil
		}

		return contents.first(where: { $0.hasSuffix(".xcodeproj") })
	}

	private func resolvedConfigFileURL(projectRootURL: URL) -> URL? {
		if let path = configFilePath {
			return URL(fileURLWithPath: path, isDirectory: false)
		}

		let defaultURL = projectRootURL.deletingLastPathComponent().appendingPathComponent(".xclint.yml", isDirectory: false)
		let path = defaultURL.path

		guard FileManager.default.isReadableFile(atPath: path) else {
			return nil
		}

		return defaultURL
	}

	private func resolvedConfiguration(projectRootURL: URL) throws -> Configuration {
		guard let url = resolvedConfigFileURL(projectRootURL: projectRootURL) else {
			return Configuration()
		}

		let data = try Data(contentsOf: url)
		return try YAMLDecoder().decode(Configuration.self, from: data)
	}
}
