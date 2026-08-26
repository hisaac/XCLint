import XCConfig

/// `XCConfig.BuildSetting`, under a name that is unambiguous alongside `XcodeProj`.
///
/// `XcodeProj` vends its own `BuildSetting` type, and its `XCConfig` class shadows the
/// `XCConfig` module name, so neither the bare name nor a module-qualified one resolves in
/// a file that imports both. This file imports only `XCConfig`, where the name is unambiguous.
typealias XCConfigBuildSetting = BuildSetting
