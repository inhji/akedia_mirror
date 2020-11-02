defmodule AkediaWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :akedia

  plug Plug.Static,
    at: "/",
    from: Path.expand("./uploads"),
    gzip: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :akedia,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt site.webmanifest sw.js)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_akedia_key",
    signing_salt: "2b6cefd2-907c-495a-8efb-3d2ec8b71263",
    encryption_salt: "c27d3eef-ab92-4793-941a-b6ed5e7fa3ef",
    # 2 Weeks
    max_age: 60 * 60 * 24 * 7 * 2,
    http_only: true

  plug AkediaWeb.Router
end
