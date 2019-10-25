defmodule PrettyLog.MixProject do
  use Mix.Project

  def project do
    [
      app: :pretty_log,
      version: "0.1.0",
      elixir: "~> 1.8",
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/ispirata/pretty_log"
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:logfmt, "~> 3.3"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]
  end

  defp description do
    "An Elixir log formatter library."
  end

  defp package do
    [
      maintainers: ["Davide Bettio"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => "https://github.com/ispirata/pretty_log",
        "Documentation" => "http://hexdocs.pm/pretty_log/"
      }
    ]
  end
end
