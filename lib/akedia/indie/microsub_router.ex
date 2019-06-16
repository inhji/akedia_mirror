defmodule Akedia.Indie.MicrosubRouter do
  use Plug.Router

  @supported_actions ["channels"]

  plug :match
  plug :dispatch

  get "/" do
    with {:ok, action, conn} <- get_action(conn) do
      handle_action(conn, action)
    else
      {:error, reason} ->
        send_error(conn, reason)
    end
  end

  match _ do
    send_resp(conn, 404, "Not found!")
  end

  def get_action(%{query_params: %{"action" => action}} = conn) do
    if not Enum.member?(@supported_actions, action) do
      {:error, "Bad action"}
    else
      {:ok, String.to_atom(action), conn}
    end
  end

  def get_action(%{query_params: _}), do: {:error, "Bad Request"}

  def handle_action(conn, :channels) do
    notification_channel =
      Akedia.Indie.Microsub.get_notification_channel()
      |> prepare_channel()

    other_channels =
      Akedia.Indie.Microsub.list_channels()
      |> Enum.filter(fn c -> c.uid != "notifications" end)
      |> Enum.map(&prepare_channel/1)

    send_response(conn, %{channels: [notification_channel | other_channels]})
  end

  def prepare_channel(channel) do
    %{
      uid: channel.uid,
      name: channel.name
    }
  end

  def send_response(conn, response) do
    body = Jason.encode!(response)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, body)
  end

  def send_error(conn, reason) do
    body =
      Jason.encode!(%{
        error: reason
      })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:bad_request, body)
  end
end
