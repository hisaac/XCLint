class Xclint < Formula
  desc "Xcode project linting"
  homepage "https://github.com/hisaac/XCLint"
  url "https://github.com/hisaac/XCLint.git", branch: "main"
  version "0.1.5"
  head "https://github.com/hisaac/XCLint", branch: "main"

  depends_on xcode: ["15.0", :build]

  def install
    system "xcrun", "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclint"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/xclint --version").strip
  end
end
