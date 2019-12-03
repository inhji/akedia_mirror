defmodule AkediaWeb.Plugs.PlugWebmention do
  @moduledoc """
  A plug for building a Microsub server.
  """
  use Plug.Router
  require Logger

  plug(:match)
  plug(:dispatch)

  def init(opts) do
    handler =
      Keyword.get(opts, :handler) ||
        raise ArgumentError, "Webmention Plug requires :handler option"

    json_encoder =
      Keyword.get(opts, :json_encoder) ||
        raise ArgumentError, "Webmention Plug requires :json_encoder option"

    [handler: handler, json_encoder: json_encoder]
  end

  def call(conn, opts) do
    conn = put_private(conn, :plug_webmention, opts)
    super(conn, opts)
  end

  post "/hook" do
    handler = get_opt(conn, :handler)

    Logger.info("Webmention hook route hit. Webmention handler engaging!")

    with json <- keys_to_atoms(conn.params),
         :ok <- handler.handle_receive(json) do
      send_response(conn)
    else
      _ -> send_error(conn, "error")
    end
  end

  match _ do
    Logger.debug("Unknown route!")
    send_resp(conn, 404, "Not found!")
  end

  def keys_to_atoms(string_key_map) when is_map(string_key_map) do
    for {key, val} <- string_key_map, into: %{}, do: {String.to_atom(key), keys_to_atoms(val)}
  end

  def keys_to_atoms(value), do: value

  def get_opt(conn, opt) do
    conn.private[:plug_webmention][opt]
  end

  def send_response(conn, response) do
    json_encoder = get_opt(conn, :json_encoder)
    body = json_encoder.encode!(response)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, body)
  end

  def send_response(conn) do
    send_response(conn, %{})
  end

  def send_error(conn, reason, code \\ :invalid_request) do
    json_encoder = get_opt(conn, :json_encoder)
    error_code = get_error_code(code)

    body =
      json_encoder.encode!(%{
        error: reason
      })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(error_code, body)
  end

  def get_error_code(:insufficient_scope), do: :unauthorized
  def get_error_code(:invalid_request), do: :bad_request
  def get_error_code(code), do: code
end
