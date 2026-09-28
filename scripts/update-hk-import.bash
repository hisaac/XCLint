#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Example import headers to be updated:
# amends "package://github.com/jdx/hk/releases/download/v2.0.1/hk@2.0.1#/Config.pkl"
# import "package://github.com/jdx/hk/releases/download/v2.0.1/hk@2.0.1#/Builtins.pkl"

function main() {
	local -r config_path="${PROJECT_ROOT}/hk.pkl"
	if [[ ! -f "${config_path}" ]]; then
		log_error "Config file not found: ${config_path}"
		exit 1
	fi

	local -r hk_version="$(hk version | head -n 1)"

	log_info "Updating hk imports in ${config_path} to version ${hk_version}"

	# Rewrite matching package URLs without relying on platform-specific sed -i behavior.
	local -r temp_path="$(mktemp "${TMPDIR:-/tmp}/update-hk-import.XXXXXX")"

	sed -E \
		"s|package://github\.com/jdx/hk/releases/download/v[^/]+/hk@[^#]+#/|package://github.com/jdx/hk/releases/download/v${hk_version}/hk@${hk_version}#/|g" \
		"${config_path}" >"${temp_path}" || exit 1

	cat "${temp_path}" >"${config_path}"
}

main "$@"
