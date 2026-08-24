// swift-tools-version: 6.3

import PackageDescription

let package = Package(
	name: "XCLint",
	platforms: [.macOS(.v13)],
	products: [
		.executable(name: "xclint", targets: ["clitool"]),
		.library(name: "XCLinting", targets: ["XCLinting"]),
	],
	dependencies: [
		.package(
			url: "https://github.com/apple/swift-argument-parser",
			revision: "6a52f3251125d74daf04fcbd5e6f08a75d074382" // 1.8.2
		),
		.package(
			url: "https://github.com/hisaac/XCConfig",
			revision: "f8b9220ec495e85546aa9f6775f14a391cef1421" // 0.1.0
		),
		.package(
			url: "https://github.com/jpsim/Yams.git",
			revision: "a27b21e0c81c5bf42049b897a62aaf387e80f279" // 6.2.2
		),
		.package(
			url: "https://github.com/tuist/XcodeProj",
			revision: "cfc3234fa2a60babbd26712ac0dec0d44734c019" // 9.16.0
		),
	],
	targets: [
		.executableTarget(
			name: "clitool",
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
