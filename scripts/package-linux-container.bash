#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Runs the Linux release build on macOS inside a Linux container, using Apple's
# `container` tool (https://github.com/apple/container).
#
# Set CONTAINER_ARCH to arm64 (default, native and fast on Apple Silicon) or
# amd64 to match what CI ships. amd64 on an Apple Silicon host is emulated and
# noticeably slower.

declare -r image="${SWIFT_IMAGE:-swift:6.3}"
declare -r arch="${CONTAINER_ARCH:-arm64}"

function main() {
	if ! command -v container >/dev/null 2>&1; then
		log_error "Apple's 'container' tool is not installed. Try: brew install container"
		exit 1
	fi

	if ! container system status >/dev/null 2>&1; then
		log_info "Starting the container service..."
		container system start
	fi

	log_info "Building in ${image} (${arch})"

	# A separate scratch path keeps Linux object files from colliding with the
	# macOS ones already in .build.
	container run --rm \
		--arch "${arch}" \
		--volume "${PROJECT_ROOT}:/src" \
		--workdir /src \
		--env "BUILD_DIR=/src/.build-linux" \
		"${image}" \
		scripts/package-linux.bash
}

main "$@"
