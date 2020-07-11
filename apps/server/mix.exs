defmodule Server.MixProject do
  use Mix.Project

  def project do
    [
      app: :server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Server.Application, []}
    ]
  end

  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_sns, "~> 2.0"},
      {:ex_aws_sqs, "~> 3.2"},
      {:jason, "~> 1.2"},
      {:saxy, "~> 1.1"},
      {:hackney, "~> 1.9"}
    ]
  end
end
