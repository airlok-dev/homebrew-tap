class Airlok < Formula
  desc "A privacy airlock between your code and third-party models: a terminal coding agent that redacts secrets before they leave your machine."
  homepage "https://airlok.dev"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.5.0/airlok-aarch64-apple-darwin.tar.xz"
      sha256 "e2481ca7ce495dbc79ceb83f772bdc4dbbb31686e58b453c9c7b3b4753c48dba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.5.0/airlok-x86_64-apple-darwin.tar.xz"
      sha256 "8146b28f7eebc3c02adf8c918b4771346337d2598573b0012ac87b1ca7bf5b9e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.5.0/airlok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c07b96d2101ff64dddf2f9d93de778441386e0b645d5f57842ee0d6ec74fe8b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.5.0/airlok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "011ef71cfdf346d94ae71e590cf1e0b3176e670a9c95d4a1198c6b3065ac08c1"
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
