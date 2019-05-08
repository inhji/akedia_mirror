defmodule AkediaWeb.Helpers.User do
  alias AkediaWeb.Router.Helpers, as: Routes

  def logged_in?(%{assigns: %{current_user: current_user}} = _conn) do
    !!current_user
  end

  def avatar_path(conn) do
    Routes.static_path(conn, "/images/me.jpg")
  end
end
