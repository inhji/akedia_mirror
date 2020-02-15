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

config :akedia, Akedia.Config,
  site_title: "Inhji.de",
  weather_location: "50.583830,8.677890",
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

config :akedia, Akedia.Scheduler,
  jobs: [
    {"*/30 * * * *", {Que, :add, [Akedia.Workers.Feeder, nil]}}
  ]

# Configures the endpoint
config :akedia, AkediaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iVePfwoS3NVsO3P3lcGct/05yT8xDjWNANBanomxJtdlEn60UoUfYiyShUA5c3KH",
  render_errors: [view: AkediaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Akedia.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.Local

config :scrivener_html,
  routes_helper: AkediaWeb.Router.Helpers,
  view_style: :bulma

config :mime, :types, %{
  "application/activity+json" => ["jsonap"],
  "application/xrd+xml" => ["xrd"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
