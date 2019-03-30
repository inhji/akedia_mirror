defmodule Akedia.Auth.Plug do
  import Plug.Conn, only: [assign: 3]
  alias Akedia.Accounts

  def current_user(conn, _) do
    current_token = Guardian.Plug.current_token(conn)
    case Akedia.Auth.Guardian.resource_from_token(current_token) do
      {:ok, user, _claims} ->
        conn |> assign(:current_user, user)
      {:error, _reason} ->
        conn
        |> assign(:current_user, nil)
        |> assign(:has_user, Accounts.has_user?())
    end
  end
end
