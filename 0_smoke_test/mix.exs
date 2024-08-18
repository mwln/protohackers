defmodule SmokeTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :smoke_test,
      version: "0.0.1",
      elixir: "~> 1.17",
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    []
  end
end
