class Qspro < Formula
  desc "OpenAI-compatible CLI for QuickSilver Pro — LLM chat and FLUX image generation"
  homepage "https://quicksilverpro.io"
  url "https://files.pythonhosted.org/packages/42/8f/abbd76ddafbb27b3105225be473d0371f96201622fe23d4edfe15c212f58/quicksilverpro-0.3.0.tar.gz"
  sha256 "6151f178c43382d41e162c17f916d4c56a8a66989f07f7db3f64a2f4f7fa38e0"
  license "MIT"
  head "https://github.com/machinefi/qspro-cli.git", branch: "main"

  depends_on "python@3.12"

  def install
    python3 = Formula["python@3.12"].opt_bin/"python3.12"

    # Isolated venv so we don't collide with user's Python env.
    system python3, "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # Install from PyPI (url+sha above); pins to the exact released version.
    system venv_pip, "install", "--no-cache-dir", "quicksilverpro==0.3.0"

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
