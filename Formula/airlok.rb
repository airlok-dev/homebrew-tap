class Airlok < Formula
  desc "A privacy airlock between your code and third-party models: a terminal coding agent that redacts secrets before they leave your machine."
  homepage "https://airlok.dev"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.2.0/airlok-aarch64-apple-darwin.tar.xz"
      sha256 "c70aa380a1ae9637149cae2ef043b4e26ca392a03165c9faacdd959a4185f64b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.2.0/airlok-x86_64-apple-darwin.tar.xz"
      sha256 "7f0030c3728b4c3a85ce12f8c9df498134195dbe91379144852c568370becbb9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.2.0/airlok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f904832e4cc5add2e446912f5fb0809942e9750e5c0bf433fc6da5fe8cb4a282"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.2.0/airlok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46870accc4d846b3c5fff498c8c5d11663cb67a615877f3bcf9c64245a20725d"
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
