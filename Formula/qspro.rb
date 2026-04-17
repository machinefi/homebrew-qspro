class Qspro < Formula
  desc "OpenAI-compatible CLI for QuickSilver Pro — DeepSeek V3, R1, Qwen 3.5"
  homepage "https://quicksilverpro.io"
  url "https://files.pythonhosted.org/packages/08/07/526b0e1762b4f56c1acb5724b831879ef5734e1c52ac50caa17150532382/quicksilverpro-0.1.0.tar.gz"
  sha256 "2ad04ffa4aab06bc9a9a4b5efe6ff36749e232a03fa8e6a9bf30836699a65203"
  license "MIT"
  head "https://github.com/machinefi/qspro-cli.git", branch: "main"

  depends_on "python@3.12"

  def install
    python3 = Formula["python@3.12"].opt_bin/"python3.12"

    # Isolated venv so we don't collide with user's Python env.
    system python3, "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # Install from PyPI (url+sha above); pins to the exact released version.
    system venv_pip, "install", "--no-cache-dir", "quicksilverpro==0.1.0"

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
