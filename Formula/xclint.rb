class Xclint < Formula
	desc "Xcode project linting"
	homepage "https://github.com/hisaac/XCLint"
	version "0.1.5"
	license "BSD-3-Clause"

	url "https://github.com/hisaac/XCLint/releases/download/0.1.5/xclint-0.1.5-universal-apple-macosx.tar.gz"
	sha256 "0000000000000000000000000000000000000000000000000000000000000000"

	# macOS only for now. A distributable Linux binary is blocked upstream: see
	# the versioning section of CLAUDE.md.
	depends_on :macos

	# `brew install --HEAD xclint` builds from main instead of downloading a
	# release binary. It needs a Swift 6.3+ toolchain on PATH (see .version and
	# Package.swift's swift-tools-version); no Xcode version is assumed.
	head do
		url "https://github.com/hisaac/XCLint.git", branch: "main"
	end

	def install
		if build.head?
			system "swift", "build", "--configuration", "release", "--disable-sandbox"
			bin.install ".build/release/xclint"
		else
			bin.install "xclint"
		end
	end

	test do
		assert_match version.to_s, shell_output("#{bin}/xclint --version")
	end
end
