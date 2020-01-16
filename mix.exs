defmodule Akedia.MixProject do
  use Mix.Project

  def project do
    [
      app: :akedia,
      version: "0.72.0",
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
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.1"},
      {:atomex, "~> 0.3.0"},
      {:bcrypt_elixir, "~> 2.0"},
      {:comeonin, "~> 5.1"},
      {:distillery, "~> 2.0"},
      {:earmark, "~> 1.4.0"},
      {:ecto_sql, "~> 3.0"},
      {:edeliver, "~> 1.6"},
      {:ex_machina, "~> 2.3", only: :test},
      {:feeder_ex, "~> 1.1"},
      {:floki, "~> 0.23.0"},
      {:gettext, "~> 0.11"},
      {:html_sanitize_ex, "~> 1.3"},
      {:httpoison, "~> 1.6"},
      {:indieweb, "~> 0.0.42"},
      {:jason, "~> 1.0"},
      {:microformats2, "0.2.1"},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_active_link, "~> 0.3.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:plug_micropub, git: "https://github.com/inhji/plug_micropub.git", branch: "master"},
      {:postgrex, ">= 0.0.0"},
      {:qr_code, "~> 2.1.0"},
      {:quantum, "~> 2.3"},
      {:que, "~> 0.10.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:scrivener_html, "~> 1.8"},
      {:slugger, "~> 0.3.0"},
      {:timex, "~> 3.5"},
      {:totpex, "~> 0.1.3"},
      {:tzdata, "~> 1.0.0"},
      {:web_authn_ex, "~> 0.1.1"},
      {:webmentions, git: "https://github.com/inhji/webmentions-elixir", branch: "update-deps"},
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
