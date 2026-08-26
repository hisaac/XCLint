#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib/common.bash" || exit 1

# Rewrites Formula/xclint.rb to point at the release assets for a given version.
#
# Usage: update-formula.bash <version> <macos-sha256> <linux-sha256>

function main() {
	local -r version="${1:-}"
	local -r macos_sha256="${2:-}"
	local -r linux_sha256="${3:-}"

	if [[ -z "${version}" || -z "${macos_sha256}" || -z "${linux_sha256}" ]]; then
		log_error "Usage: ${script_name} <version> <macos-sha256> <linux-sha256>"
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

	sed \
		-e "s|^\(\tversion \).*|\1\"${version}\"|" \
		-e "s|^\(\t\turl \"\).*\(/xclint-\)[^\"]*\(-universal-apple-macosx\.tar\.gz\"\)|\1${base_url}\2${version}\3|" \
		-e "s|^\(\t\turl \"\).*\(/xclint-\)[^\"]*\(-x86_64-unknown-linux-gnu\.tar\.gz\"\)|\1${base_url}\2${version}\3|" \
		"${formula_path}" >"${temp_path}"

	# The two sha256 lines are positional: the first belongs to the on_macos
	# block, the second to on_linux. Rewrite them in order.
	awk -v macos="${macos_sha256}" -v linux="${linux_sha256}" '
		/^\t\tsha256 "/ {
			count++
			if (count == 1) { print "\t\tsha256 \"" macos "\""; next }
			if (count == 2) { print "\t\tsha256 \"" linux "\""; next }
		}
		{ print }
	' "${temp_path}" >"${formula_path}"

	rm -f "${temp_path}"

	log_info "Formula updated:"
	grep -E '^\t(version|\tsha256|\turl)' "${formula_path}"
}

main "$@"
