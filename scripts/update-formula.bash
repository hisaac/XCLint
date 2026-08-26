#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Rewrites Formula/xclint.rb to point at the release assets for a given version.
#
# Usage: update-formula.bash <version> <macos-sha256>

function main() {
	local -r version="${1:-}"
	local -r macos_sha256="${2:-}"

	if [[ -z "${version}" || -z "${macos_sha256}" ]]; then
		log_error "Usage: ${script_name} <version> <macos-sha256>"
		exit 1
	fi

	local -r formula_path="${PROJECT_ROOT}/Formula/xclint.rb"
	if [[ ! -f "${formula_path}" ]]; then
		log_error "Formula not found: ${formula_path}"
		exit 1
	fi

	log_info "Updating formula to ${version}"

	local -r base_url="https://github.com/hisaac/XCLint/releases/download/${version}"
	local -r temp_path="$(mktemp)"

	# Anchored to a single leading tab so the `head do` block's url, which is
	# indented one level deeper, is left alone.
	sed \
		-e "s|^\(\tversion \).*|\1\"${version}\"|" \
		-e "s|^\(\turl \"\).*\(/xclint-\)[^\"]*\(-universal-apple-macosx\.tar\.gz\"\)|\1${base_url}\2${version}\3|" \
		-e "s|^\(\tsha256 \"\)[^\"]*\(\"\)|\1${macos_sha256}\2|" \
		"${formula_path}" >"${temp_path}"

	mv "${temp_path}" "${formula_path}"

	log_info "Formula updated:"
	grep -E '^\t(version|url|sha256)' "${formula_path}"
}

main "$@"
