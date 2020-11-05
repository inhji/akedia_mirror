use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :akedia, AkediaWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :akedia, Akedia.Repo,
  username: "postgres",
  password: "postgres",
  database: "akedia_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :akedia, Oban, 
	crontab: false, 
	queues: false, 
	plugins: false
