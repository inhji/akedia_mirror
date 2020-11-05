# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :akedia,
  ecto_repos: [Akedia.Repo]

config :akedia, Oban,
  repo: Akedia.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

config :akedia, Akedia.Config,
  site_title: "Inhji.de",
  bridgy_endpoint: "https://brid.gy/publish/webmention",
  bridgy_github_target: "https://brid.gy/publish/github",
  supported_scopes: [
    # Micropub scopes
    "create",
    "update",
    "delete",
    "undelete",
    "media",
    # Microsub scopes
    "read",
    "follow",
    "mute",
    "block",
    "channels"
  ]

config :git_ops,
  mix_project: Akedia.MixProject,
  changelog_file: "CHANGELOG.md",
  repository_url: "https://git.inhji.de/inhji/akedia",
  types: [
    # Makes an allowed commit type called `tidbit` that is not
    # shown in the changelog
    tidbit: [
      hidden?: true
    ],
    # Makes an allowed commit type called `important` that gets
    # a section in the changelog with the header "Important Changes"
    important: [header: "Important Changes"],
    tweak: [header: "Tweaks"],
    ref: [header: "Refactors"]
  ],
  # Instructs the tool to manage your mix version in your `mix.exs` file
  # See below for more information
  manage_mix_version?: true,
  # Instructs the tool to manage the version in your README.md
  # Pass in `true` to use `"README.md"` or a string to customize
  manage_readme_version: "README.md",
  version_tag_prefix: "v"

# Configures the endpoint
config :akedia, AkediaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iVePfwoS3NVsO3P3lcGct/05yT8xDjWNANBanomxJtdlEn60UoUfYiyShUA5c3KH",
  render_errors: [view: AkediaWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Akedia.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :scrivener_html,
  routes_helper: AkediaWeb.Router.Helpers,
  view_style: :bulma

config :mime, :types, %{
  "application/activity+json" => ["jsonap"],
  "application/xrd+xml" => ["xrd"]
}

config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: "uploads"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
