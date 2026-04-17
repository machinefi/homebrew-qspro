class Qspro < Formula
  desc "OpenAI-compatible CLI for QuickSilver Pro — DeepSeek V3, R1, Qwen 3.5"
  homepage "https://quicksilverpro.io"
  url "https://files.pythonhosted.org/packages/e4/e8/c99a1dc7144caafb7244e2a20c346f9ddc4924ffbff3827b46a22eaf0e2e/quicksilverpro-0.1.1.tar.gz"
  sha256 "35298303dff08f0f921daf6df85d35bb3615cae882a56a841b0700900a6a2d8b"
  license "MIT"
  head "https://github.com/machinefi/qspro-cli.git", branch: "main"

  depends_on "python@3.12"

  def install
    python3 = Formula["python@3.12"].opt_bin/"python3.12"

    # Isolated venv so we don't collide with user's Python env.
    system python3, "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # Install from PyPI (url+sha above); pins to the exact released version.
    system venv_pip, "install", "--no-cache-dir", "quicksilverpro==0.1.1"

    # Expose both the short and long entry points.
    %w[qsp quicksilverpro].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin"/cmd, PATH: "#{libexec}/bin:${PATH}"
    end
  end

  def caveats
    <<~EOS
      Get started:
        qsp init             # opens dashboard, paste your API key
        qsp chat "Hello"     # one-shot streaming chat (deepseek-v3 by default)
        qsp balance          # credits remaining
        qsp --help

      Docs: https://quicksilverpro.io/dashboard#quickstart
      Status: https://quicksilverpro.io/status
    EOS
  end

  test do
    assert_match "qsp", shell_output("#{bin}/qsp --version 2>&1", 0)
  end
end
