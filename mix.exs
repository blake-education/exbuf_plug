defmodule ExbufPlug.Mixfile do
  use Mix.Project

  def project do
    [app: :exbuf_plug,
     version: "0.0.3",
     elixir: "~> 1.2",
     description: "A small plug to handle decoding protocol buffers.",
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :cowboy, :plug]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:exprotobuf, "~> 1.1", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Garrett Heinlen"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/gogogarrett/exbuf_plug"}
    ]
  end
end
