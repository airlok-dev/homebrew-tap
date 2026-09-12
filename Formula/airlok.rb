class Airlok < Formula
  desc "A privacy airlock between your code and third-party models: a terminal coding agent that redacts secrets before they leave your machine."
  homepage "https://airlok.dev"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.6.1/airlok-aarch64-apple-darwin.tar.xz"
      sha256 "73dc3596943749659b98a7ef1500eb4e61f94ccf7cd79782242b9397eb49db50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.6.1/airlok-x86_64-apple-darwin.tar.xz"
      sha256 "0f74f3bfba94f236c1e6bf21c9d4d6e6ef8d3122c0664ffb0732ec8343335f96"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.6.1/airlok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eca98768d941e8574a8f9c5a590f6baf4a13111d249a1def10152321fc5554fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.6.1/airlok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2e310ae517f060c45bed5a086a85ec91c284551b4feb25e2841b9ef92162b72e"
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
