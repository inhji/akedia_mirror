defmodule AkediaWeb.Helpers.User do
  alias AkediaWeb.Router.Helpers, as: Routes
  import Plug.Conn, only: [get_session: 2]

  def logged_in?(conn) do
    case get_session(conn, :user_id) do
      nil -> false
      _ -> true
    end
  end

  def avatar_path(conn) do
    Routes.static_path(conn, "/images/me.jpg")
  end
end
