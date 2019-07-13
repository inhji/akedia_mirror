defmodule AkediaWeb.Helpers.User do
  import Plug.Conn, only: [get_session: 2]

  def logged_in?(conn) do
    case get_session(conn, :user_id) do
      nil -> false
      _ -> true
    end
  end
end
