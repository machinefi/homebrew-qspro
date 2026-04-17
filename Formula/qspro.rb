class Qspro < Formula
  desc "OpenAI-compatible CLI for QuickSilver Pro — DeepSeek V3, R1, Qwen 3.5"
  homepage "https://quicksilverpro.io"
  url "https://files.pythonhosted.org/packages/1c/db/0df99168a8490e68c727191c1f0cfe40bdfc407f79c22980173d4191a18f/quicksilverpro-0.1.2.tar.gz"
  sha256 "f52503603c773d996741c934c93c18e90d3e1a898c2c1a9c66751f0ce9016534"
  license "MIT"
  head "https://github.com/machinefi/qspro-cli.git", branch: "main"

  depends_on "python@3.12"

  def install
    python3 = Formula["python@3.12"].opt_bin/"python3.12"

    # Isolated venv so we don't collide with user's Python env.
    system python3, "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # Install from PyPI (url+sha above); pins to the exact released version.
    system venv_pip, "install", "--no-cache-dir", "quicksilverpro==0.1.2"

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
