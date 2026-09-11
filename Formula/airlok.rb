class Airlok < Formula
  desc "A privacy airlock between your code and third-party models: a terminal coding agent that redacts secrets before they leave your machine."
  homepage "https://airlok.dev"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.4.0/airlok-aarch64-apple-darwin.tar.xz"
      sha256 "dbc4df1849bbae015970a5c0dff87e1d46e6b8f08f2f4f0ef96699b46936e4dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.4.0/airlok-x86_64-apple-darwin.tar.xz"
      sha256 "9a97a54fb650d1dacd9da66b60a1ea1a4406c56bc9d1f6f47eb0bab5737c8d74"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.4.0/airlok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec787682d11a434aa077f68d88f82ec5c489187327c58fa63069cd356a9200b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.4.0/airlok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "70916eb04626fa19871a5665c670d55de4b5e54ee84a4f08a544b94ed9f8193f"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "airlok"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "airlok"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "airlok"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "airlok"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
