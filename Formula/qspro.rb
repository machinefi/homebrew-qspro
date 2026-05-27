class Qspro < Formula
  desc "OpenAI-compatible CLI for QuickSilver Pro — LLM chat and FLUX image generation"
  homepage "https://quicksilverpro.io"
  url "https://files.pythonhosted.org/packages/84/73/99038add11943cc8b8b79ae7c9aeedce633501f9aed29585a8168c9d0040/quicksilverpro-0.2.0.tar.gz"
  sha256 "5e2471f7d500973b83c4e774daa7cdb9905597119aabf4935997607e4d888886"
  license "MIT"
  head "https://github.com/machinefi/qspro-cli.git", branch: "main"

  depends_on "python@3.12"

  def install
    python3 = Formula["python@3.12"].opt_bin/"python3.12"

    # Isolated venv so we don't collide with user's Python env.
    system python3, "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # Install from PyPI (url+sha above); pins to the exact released version.
    system venv_pip, "install", "--no-cache-dir", "quicksilverpro==0.2.0"

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
