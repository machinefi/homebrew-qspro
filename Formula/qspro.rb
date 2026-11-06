class Qspro < Formula
  desc "OpenAI-compatible CLI for QuickSilver Pro — LLM chat and FLUX image generation"
  homepage "https://quicksilverpro.io"
  url "https://files.pythonhosted.org/packages/2b/7f/419232718b3c4b69634f8a0d315b50962f52f23fd0071281aed762cf5feb/quicksilverpro-0.5.2.tar.gz"
  sha256 "3ff2aeb66eba0c3efffe1b7c58f1b60e2ae18c7f1bf8bb2eb5565186d05c2a4c"
  license "MIT"
  head "https://github.com/machinefi/qspro-cli.git", branch: "main"

  depends_on "python@3.12"

  def install
    python3 = Formula["python@3.12"].opt_bin/"python3.12"

    # Isolated venv so we don't collide with user's Python env.
    system python3, "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # Install from PyPI (url+sha above); pins to the exact released version.
    system venv_pip, "install", "--no-cache-dir", "quicksilverpro==0.5.2"

    # Expose both the short and long entry points.
    %w[qsp quicksilverpro].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin"/cmd, PATH: "#{libexec}/bin:${PATH}"
    end
  end

  def caveats
    <<~EOS
      Get started:
        qsp init                       # opens dashboard, paste your API key
        qsp chat "Hello"               # one-shot streaming chat (deepseek-v4-flash by default)
        qsp image "a fox" -o fox.jpg   # text-to-image (FLUX)
        qsp balance                    # credits remaining
        qsp --help

      Docs: https://quicksilverpro.io/dashboard#quickstart
      Status: https://quicksilverpro.io/status
    EOS
  end

  test do
    assert_match "qsp", shell_output("#{bin}/qsp --version 2>&1")
  end
end
