defmodule AkediaWeb.Responses do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  require Logger

  def bad_request(conn, message \\ "Bad Request") do
    send_error(conn, message, 400)
  end

  def unauthorized(conn, message \\ "Unauthorized") do
    send_error(conn, message, 401)
  end

  def send_error(conn, message, status) do
    Logger.warn(message)

    conn
    |> put_status(status)
    |> json(%{error: message})
    |> halt()
  end
end
