defmodule M.MixProject do
  use Mix.Project

  def project do
    [
      app: :reverse_match,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      description: "Functions and macros to help write elixir more fluent.",
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp package do
    [
      licenses: ["MIT"],
      name: "reverse_match",
      links: %{"GitHub" => "https://github.com/KeepZen/reverse_match"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
