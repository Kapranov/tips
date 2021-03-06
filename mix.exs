defmodule Tips.MixProject do
  use Mix.Project

  def project do
    [
      app: :tips,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Tips.Application, []}
    ]
  end

  defp deps do
    []
  end
end
