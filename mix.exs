defmodule Akedia.MixProject do
  use Mix.Project

  @version "0.91.2"

  def project do
    [
      app: :akedia,
      version: @version,
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      source_url: "https://git.inhji.de/inhji/akedia",
      homepage_url: "https://inhji.de",
      docs: docs()
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
        :open_graph,
        :scrivener_ecto,
        :scrivener_html,
        :rsa_ex
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
      {:bcrypt_elixir, "~> 2.0"},
      {:credo, "~> 1.2", only: :dev},
      {:earmark, "~> 1.4.0"},
      {:ecto_sql, "~> 3.0"},
      {:ex_cli, "~> 0.1.0"},
      {:ex_doc, "~> 0.23.0", only: :dev, runtime: false},
      {:ex_machina, "~> 2.3", only: :test},
      {:floki, "~> 0.29.0"},
      {:gettext, "~> 0.18"},
      {:git_ops, "~> 2.0.1", only: [:dev, :test]},
      {:html_sanitize_ex, "~> 1.3"},
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.0"},
      {:mock, "~> 0.3.6", only: :test},
      {:nimble_parsec, "~> 1.1", override: true},
      {:open_graph, "~> 0.0.4"},
      {:oban, "~> 2.2"},
      {:phoenix, "~> 1.5"},
      {:phoenix_active_link, "~> 0.3.0"},
      {:phoenix_ecto, "~> 4.2"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_pubsub, "~> 2.0"},
      {:plug_cowboy, "~> 2.4"},
      {:plug_micropub, git: "https://git.inhji.de/inhji/plug_micropub", branch: "master"},
      {:postgrex, ">= 0.0.0"},
      {:qr_code, "~> 2.1.0"},
      {:rsa_ex, "~> 0.4"},
      {:scrivener_ecto, "~> 2.0", override: false},
      {:scrivener_html, git: "https://git.inhji.de/inhji/scrivener_html.git", branch: "relax-dude"},
      {:slugger, "~> 0.3.0"},
      {:timex, "~> 3.5"},
      {:totpex, "~> 0.1.3"},
      {:tzdata, "~> 1.0.0"},
      {:waffle, "~> 1.1.3"},
      {:waffle_ecto, "~> 0.0.9"},
      {:web_authn_ex, "~> 0.1.1"}
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
      restart: ["edeliver restart production"],
      migrate: ["edeliver migrate production"],
      deploy_ex: ["edeliver deploy release to production"],
      build_ex: ["edeliver build release"]
    ]
  end

  defp docs do
    [
      main: "readme",
      logo: "akedia.jpg",
      extras: [
        "README.md",
        "guides/BACKUP.md",
        "guides/BRIDGY.md",
        "guides/DEPLOY.md",
        "guides/INSTALL.md"
      ],
      authors: ["Inhji"],
      output: "docs",
      source_url_pattern: "https://git.inhji.de/inhji/akedia/src/branch/master/%{path}#L%{line}",
      nest_modules_by_prefix: [
        AkediaWeb,
        Akedia.Content,
        Akedia.Media,
        Akedia.Indie,
        Akedia.Accounts,
        Akedia.Workers,
        Akedia.Favicon,
        Akedia.Scraper,
        Akedia.Context
      ],
      groups_for_functions: [
        User: &(&1[:model] == :user),
        Credential: &(&1[:model] == :credential),
        Profile: &(&1[:model] == :profile),
        Entity: &(&1[:model] == :entity),
        Bookmark: &(&1[:model] == :bookmark),
        Post: &(&1[:model] == :post),
        Like: &(&1[:model] == :like),
        Topic: &(&1[:model] == :topic),
        Syndication: &(&1[:model] == :syndication),
        Author: &(&1[:model] == :author),
        Context: &(&1[:model] == :context),
        Query: &(&1[:utils] == :query),
        Tag: &(&1[:utils] == :tag)
      ],
      groups_for_modules: [
        Controllers: [
          AkediaWeb.AtomController,
          AkediaWeb.BookmarkController,
          AkediaWeb.ImageController,
          AkediaWeb.InboxController,
          AkediaWeb.LikeController,
          AkediaWeb.MentionController,
          AkediaWeb.OutboxController,
          AkediaWeb.PostController,
          AkediaWeb.ProfileController,
          AkediaWeb.PublicController,
          AkediaWeb.QueueController,
          AkediaWeb.SessionController,
          AkediaWeb.TopicController,
          AkediaWeb.UserController,
          AkediaWeb.WebauthnController,
          AkediaWeb.WellKnownController
        ],
        Views: [
          AkediaWeb.BookmarkView,
          AkediaWeb.ErrorView,
          AkediaWeb.ImageView,
          AkediaWeb.LayoutView,
          AkediaWeb.LikeView,
          AkediaWeb.MentionView,
          AkediaWeb.PostView,
          AkediaWeb.ProfileView,
          AkediaWeb.PublicView,
          AkediaWeb.QueueView,
          AkediaWeb.RegistrationView,
          AkediaWeb.SessionView,
          AkediaWeb.SharedView,
          AkediaWeb.TopicView,
          AkediaWeb.UserView
        ],
        "Custom Mix Tasks": [
          MixBuild,
          MixDeploy
        ]
      ]
    ]
  end
end
