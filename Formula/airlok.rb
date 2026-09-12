class Airlok < Formula
  desc "A privacy airlock between your code and third-party models: a terminal coding agent that redacts secrets before they leave your machine."
  homepage "https://airlok.dev"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.9.0/airlok-aarch64-apple-darwin.tar.xz"
      sha256 "970f9c5b7a9c95f7e3c5634b477536bc4bb807b35cffa053e2cd4643e434a18b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.9.0/airlok-x86_64-apple-darwin.tar.xz"
      sha256 "3474a9e7f355d6ad09a4b906a060f0e01c54957b33a727cef4edfa334befd323"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.9.0/airlok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7fcdb5baa157b38945b584d6ae2e9281b1d2020214c38f8a5cd2487e05764d87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/airlok-dev/airlok/releases/download/v0.9.0/airlok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "65e79d35dc52053eebe8ad12131f2ba4fb744e23a8f5c771ec6b044d6f795808"
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
