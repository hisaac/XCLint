class Xclint < Formula
  desc "Xcode project linting"
  homepage "https://github.com/hisaac/XCLint"
  url "https://github.com/hisaac/XCLint.git", branch: "main"
  head "https://github.com/hisaac/XCLint", branch: "main"
  version File.read(File.join(__dir__, "..", ".version")).strip

  # Package.swift declares swift-tools-version: 6.3, and Xcode 26.4 is the first
  # release to ship Swift 6.3 — 26.3 ships 6.2.3 and cannot parse the manifest.
  depends_on xcode: ["26.4", :build]

  def install
    system "xcrun", "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclint"
  end
end
