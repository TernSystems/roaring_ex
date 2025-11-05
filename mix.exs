defmodule Roaring.MixProject do
  use Mix.Project

  def project do
    [
      app: :roaring,
      version: "0.11.2",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.37.1", runtime: false},
      {:ecto, "~> 3.13"}
    ]
  end
end
