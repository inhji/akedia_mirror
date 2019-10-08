defmodule Akedia.MixProject do
  use Mix.Project

  def project do
    [
      app: :akedia,
      version: "0.67.5",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Akedia.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :timex,
        :que,
        :scrivener_ecto,
        :scrivener_html
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:comeonin, "~> 5.1"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_active_link, "~> 0.2.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:earmark, "~> 1.4.0"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.1"},
      {:ex_machina, "~> 2.3", only: :test},
      {:distillery, "~> 2.0"},
      {:edeliver, "~> 1.6"},
      {:plug_micropub, git: "https://github.com/inhji/plug_micropub.git", branch: "master"},
      {:httpoison, "~> 1.6", override: true},
      {:timex, "~> 3.5"},
      {:que, "~> 0.10.0"},
      {:quantum, "~> 2.3"},
      {:webmentions, "~> 0.3.4"},
      {:slugger, "~> 0.3.0"},
      {:microformats2, "~> 0.2.1"},
      {:floki, "~> 0.22.0"},
      {:indieweb, "~> 0.0.42"},
      {:scrivener_ecto, "~> 2.0"},
      {:scrivener_html, "~> 1.8"},
      {:feeder_ex, "~> 1.1"},
      {:tzdata, "~> 1.0.0"},
      {:html_sanitize_ex, "~> 1.3"},
      {:atomex, "~> 0.3.0"},
      {:emojix, "~> 0.1.0"},
      {:web_authn_ex, "~> 0.1.1"},
      {:totpex, "~> 0.1.3"},
      {:qr_code, "~> 2.1.0"},
      {:xml_builder, "~> 2.1.1", override: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      build: ["edeliver build release"],
      deploy: ["edeliver deploy release to production"],
      restart: ["edeliver restart production"],
      migrate: ["edeliver migrate production"]
    ]
  end
end
