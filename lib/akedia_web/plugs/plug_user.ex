defmodule AkediaWeb.Plugs.PlugUser do
  import Plug.Conn, only: [assign: 3, get_session: 2, configure_session: 2]
  import Phoenix.Controller, only: [render: 2, put_layout: 2, put_view: 2]
  alias Akedia.Accounts
  alias AkediaWeb.{ErrorView, LayoutView}

  def check_user(conn, _) do
    IO.inspect(get_session(conn, :user_id))

    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_layout({LayoutView, "app.html"})
        |> put_view(ErrorView)
        |> assign(:logged_in, false)
        |> render("auth.html")

      _ ->
        conn
        |> assign(:logged_in, true)
    end
  end

  def check_loggedin(conn, _) do
    case get_session(conn, :user_id) do
      nil -> assign(conn, :logged_in, false)
      _ -> assign(conn, :logged_in, true)
    end
  end

  def refresh_user(conn, _) do
    case get_session(conn, :user_id) do
      nil -> conn
      _ -> configure_session(conn, renew: true)
    end
  end

  def assign_user(conn, _) do
    case Accounts.user_exists?() do
      false ->
        conn
        |> assign(:current_user, nil)
        |> assign(:has_user, false)

      _ ->
        user = Accounts.get_user!()

        conn
        |> assign(:current_user, user)
        |> assign(:has_user, true)
    end
  end
end
