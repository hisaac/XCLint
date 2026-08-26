#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Builds a universal (arm64 + x86_64) macOS binary and packages it for release.

function main() {
	local -r version="$(tr -d '[:space:]' <"${PROJECT_ROOT}/.version")"
	local -r dist_dir="${PROJECT_ROOT}/dist"
	local -r archive="${dist_dir}/xclint-${version}-universal-apple-macosx.tar.gz"

	log_info "Building macOS universal binary for ${version} with $(swift --version | head -n 1)"

	# NOTE: SwiftPM's multi-arch form (`--arch arm64 --arch x86_64`) routes through
	# the Xcode build system, which does not generate the PackageResources accessor
	# that `.embedInCode("../../.version")` depends on, so it fails with
	# "cannot find 'PackageResources' in scope". Build each slice on its own and
	# lipo them together instead.
	swift build --configuration release --arch arm64
	swift build --configuration release --arch x86_64

	mkdir -p "${dist_dir}"
	lipo -create -output "${dist_dir}/xclint" \
		"${BUILD_DIR}/arm64-apple-macosx/release/xclint" \
		"${BUILD_DIR}/x86_64-apple-macosx/release/xclint"
	strip -rSTx "${dist_dir}/xclint"

	log_info "$(lipo -info "${dist_dir}/xclint")"
	log_info "Binary reports version: $("${dist_dir}/xclint" --version)"

	tar -czf "${archive}" -C "${dist_dir}" xclint
	log_info "Packaged ${archive}"
}

main "$@"
