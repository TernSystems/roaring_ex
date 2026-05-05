defmodule Roaring.MixProject do
  use Mix.Project

  def project do
    [
      app: :roaring,
      version: "0.13.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      description: description(),
      source_url: "https://github.com/TernSystems/roaring_ex",
      licenses: [],
      package: package(),
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
      {:ecto, "~> 3.13"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/TernSystems/roaring_ex"}
    ]
  end

  defp description() do
    "RoaringBitmaps in Elixir, compressed bitmaps powered by roaring-rs"
  end
end
