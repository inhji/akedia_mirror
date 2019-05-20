# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :akedia,
  ecto_repos: [Akedia.Repo]

config :akedia, Akedia.Settings,
  show_wiki: false,
  show_stories: false,
  show_images: false,
  show_search: false,
  show_bookmarks: false,
  show_more: false,
  show_posts: false

config :akedia, Akedia.Scheduler,
  jobs: [
    {"*/15 * * * *", {Que, :add, [Akedia.Workers.Listenbrainz, "inhji"]}}
  ]

# Configures the endpoint
config :akedia, AkediaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iVePfwoS3NVsO3P3lcGct/05yT8xDjWNANBanomxJtdlEn60UoUfYiyShUA5c3KH",
  render_errors: [view: AkediaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Akedia.PubSub, adapter: Phoenix.PubSub.PG2]

config :akedia, Akedia.Auth.AuthPipeline,
  module: Akedia.Auth.Guardian,
  error_handler: Akedia.Auth.AuthErrorHandler

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.Local

config :indieweb,
  webmention_url_adapter: Akedia.Indie.Adapters.URLAdapter

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
