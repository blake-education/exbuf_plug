defmodule ExbufPlug.Mixfile do
  use Mix.Project

  def project do
    [
      aliases: aliases(Mix.env()),
      app: :exbuf_plug,
      version: "2.0.1",
      elixir: "~> 1.16",
      description: "A small plug to handle decoding protocol buffers.",
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def aliases(_env) do
    [
      test: ["exbuf_plug.protoc", "test"]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
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
      {:cowboy, "~> 2.12"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:plug, "~> 1.16"},
      {:protobuf, "~> 0.15.0"}
    ]
  end

  defp description do
    "A plug for decoding protocol buffers"
  end

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      # name: "postgrex",
      # These are the default files included in the package
      # files: ["lib", "priv", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      organization: "blake_elearning",
      maintainers: ["Martin Stannard"],
      licenses: ["Blake"],
      links: %{"GitHub" => "https://github.com/blake-education/exbuf_plug"}
    ]
  end
end
