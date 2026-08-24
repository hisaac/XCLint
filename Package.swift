// swift-tools-version: 6.3

import PackageDescription

let package = Package(
	name: "XCLint",
	platforms: [.macOS(.v13)],
	products: [
		.executable(name: "xclint", targets: ["cli"]),
		.library(name: "XCLinting", targets: ["XCLinting"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", exact: "1.8.2"),
		.package(url: "https://github.com/hisaac/XCConfig", exact: "0.1.0"),
		.package(url: "https://github.com/jpsim/Yams", exact: "6.2.2"),
		.package(url: "https://github.com/tuist/XcodeProj", exact: "9.16.0"),
	],
	targets: [
		.executableTarget(
			name: "cli",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Yams", package: "Yams"),
				"XCLinting",
			]
		),
		.target(
			name: "XCLinting",
			dependencies: ["XCConfig", "XcodeProj"]
		),
		.testTarget(
			name: "XCLintTests",
			dependencies: ["XCLinting", "XcodeProj"],
			resources: [
				.copy("TestData"),
			]
		),
	],
	swiftLanguageModes: [.v6]
)
