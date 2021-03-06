defmodule AwsSauron.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: get_version(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        aws_sauron: [
          applications: [
            server: :permanent,
            web: :permanent
          ]
        ]
      ]
    ]
  end

  defp get_version do
    case File.read("VERSION") do
      {:ok, version} -> String.trim(version)
      _ -> "0.0.0-unknown"
    end
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
