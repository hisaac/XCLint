#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Example import headers to be updated:
# amends "package://github.com/jdx/hk/releases/download/v1.34.0/hk@1.34.0#/Config.pkl"
# import "package://github.com/jdx/hk/releases/download/v1.34.0/hk@1.34.0#/Builtins.pkl"

function main() {
	local -r config_path="${PROJECT_ROOT}/hk.pkl"
	if [[ ! -f "${config_path}" ]]; then
		log_error "Config file not found: ${config_path}"
		exit 1
	fi

	local -r hk_version="$(mise exec -- hk version | head -n 1)"

	log_info "Updating hk imports in ${config_path} to version ${hk_version}"

	local -r temp_path="$(mktemp)"
	{
		echo "amends \"package://github.com/jdx/hk/releases/download/v${hk_version}/hk@${hk_version}#/Config.pkl\""
		echo "import \"package://github.com/jdx/hk/releases/download/v${hk_version}/hk@${hk_version}#/Builtins.pkl\""
		tail -n +3 "${config_path}"
	} >"${temp_path}"

	mv "${temp_path}" "${config_path}"
}

main "$@"
