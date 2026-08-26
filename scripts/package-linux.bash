#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Builds a fully static Linux binary using the Swift Static Linux SDK and
# packages it for release. The SDK must already be installed via
# `swift sdk install` (the release workflow does this).

declare -r swift_sdk="x86_64-swift-linux-musl"

function main() {
	local -r version="$(tr -d '[:space:]' <"${PROJECT_ROOT}/.version")"
	local -r dist_dir="${PROJECT_ROOT}/dist"
	local -r archive="${dist_dir}/xclint-${version}-x86_64-linux-static.tar.gz"

	log_info "Building static Linux binary for ${version} with $(swift --version | head -n 1)"

	if ! swift sdk list | grep -q "${swift_sdk}"; then
		log_error "Swift SDK '${swift_sdk}' is not installed. Run 'swift sdk install <url> --checksum <sum>' first."
		exit 1
	fi

	swift build --configuration release --swift-sdk "${swift_sdk}"

	mkdir -p "${dist_dir}"
	cp "${BUILD_DIR}/${swift_sdk}/release/xclint" "${dist_dir}/xclint"
	strip "${dist_dir}/xclint"

	log_info "Binary reports version: $("${dist_dir}/xclint" --version)"

	tar -czf "${archive}" -C "${dist_dir}" xclint
	log_info "Packaged ${archive}"
}

main "$@"
