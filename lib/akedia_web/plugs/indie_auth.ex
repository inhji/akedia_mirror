defmodule AkediaWeb.Plugs.PlugIndieAuth do
  use Plug.Router
  import Plug.Conn

  plug :match
  plug :dispatch

  def init(opts) do
    handler =
      Keyword.get(opts, :handler) ||
        raise ArgumentError, "IndieAuth Plug requires :handler option"

    json_encoder =
      Keyword.get(opts, :json_encoder) ||
        raise ArgumentError, "IndieAuth Plug requires :json_encoder option"

    [handler: handler, json_encoder: json_encoder]
  end

  def call(conn, opts) do
    conn = put_private(conn, :plug_indieauth, opts)

    super(conn, opts)
  end

  get "/" do
    IO.inspect(conn.query_params)

    with {:ok, params} <- validate_query_params(conn.query_params) do
      conn
      |> send_resp(:ok, "LOL")
    else
      {:error, error} ->
        conn
        |> send_resp(:bad_request, error || "Bad Request")
    end
  end

  match _ do
    send_resp(conn, :bad_request, "oops")
  end

  def validate_query_params(
        %{
          "me" => me,
          "redirect_uri" => redirect_uri,
          "client_id" => client_id,
          "state" => state,
          "response_type" => response_type
        } = query_params
      ) do
    validate_me_value(me)
  end

  def validate_query_params(_), do: {:error, "Invalid params"}

  def validate_me_value(me) do
    if URI.parse(me) == Akedia.url() do
      {:ok, me}
    else
      {:error, "Me value does not match"}
    end
  end
end
