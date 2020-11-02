import Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).

totp_secret = 
	System.get_env("TOTP_SECRET") ||
	  raise """
	  environment variable TOTP_SECRET is missing.
	  You can generate one by calling: mix phx.gen.secret
	  """

config :akedia, Akedia.Config,
  weather_apikey: "815570eb6165c6ac0bda9382160dc284",
  totp_secret: totp_secret

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :akedia, AkediaWeb.Endpoint,
  url: [host: System.get_env("HOST") || "localhost"],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

upload_dir =
  System.get_env("UPLOAD_DIR") ||
    raise """
    environment variable UPLOAD_DIR is missing.
    for example: /opt/akedia/uploads
    """

config :waffle,
  storage_dir_prefix: upload_dir

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :akedia, Akedia.Repo,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :akedia, AkediaWeb.Endpoint, server: true