#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Builds a Linux release binary and packages it for release. Must run on Linux:
# in CI, or on macOS via `mise run package-linux-container`.
#
# `-static-stdlib` bakes the Swift runtime into the binary so no toolchain is
# needed at runtime. glibc, ICU and libxml2 are still linked dynamically, so the
# result targets the distro it was built on — CI pins ubuntu-24.04.
#
# NOTE: the fully static Swift Static Linux SDK (musl) does NOT work for this
# package. PathKit, pulled in by XcodeProj, does `#if os(Linux) import Glibc`,
# and there is no Glibc module under musl. PathKit 1.0.1 is the latest release
# and XcodeProj 9.16.0 still depends on it, so there is nothing to upgrade into.

function main() {
	local -r version="$(tr -d '[:space:]' <"${PROJECT_ROOT}/.version")"
	local -r arch="$(uname -m)"
	local -r dist_dir="${PROJECT_ROOT}/dist"
	local -r archive="${dist_dir}/xclint-${version}-${arch}-unknown-linux-gnu.tar.gz"

	if [[ "$(uname -s)" != "Linux" ]]; then
		log_error "This script must run on Linux. On macOS use: mise run package-linux-container"
		exit 1
	fi

	log_info "Building Linux binary (${arch}) for ${version} with $(swift --version | head -n 1)"

	swift build --configuration release -Xswiftc -static-stdlib --scratch-path "${BUILD_DIR}"

	mkdir -p "${dist_dir}"
	cp "${BUILD_DIR}/release/xclint" "${dist_dir}/xclint"
	strip "${dist_dir}/xclint"

	log_info "Binary reports version: $("${dist_dir}/xclint" --version)"
	log_info "Dynamically links: $(ldd "${dist_dir}/xclint" | awk '{print $1}' | grep -c '\.so')" "shared objects"

	tar -czf "${archive}" -C "${dist_dir}" xclint
	log_info "Packaged ${archive}"
}

main "$@"
