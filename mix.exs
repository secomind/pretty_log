defmodule PrettyLog.MixProject do
  use Mix.Project

  @source_url "https://github.com/ispirata/pretty_log"
  @version "0.9.0"

  def project do
    [
      app: :pretty_log,
      version: @version,
      elixir: "~> 1.8",
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:logfmt, "~> 3.3"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      description: "An Elixir log formatter library.",
      maintainers: ["Davide Bettio"],
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
