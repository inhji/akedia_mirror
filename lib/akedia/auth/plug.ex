defmodule Akedia.Auth.Plug do
  import Plug.Conn, only: [assign: 3, get_session: 2, configure_session: 2]
  import Phoenix.Controller, only: [render: 2, put_layout: 2, put_view: 2]
  alias Akedia.Accounts
  alias AkediaWeb.{ErrorView, LayoutView}

  def check_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_layout({LayoutView, "app.html"})
        |> put_view(ErrorView)
        |> render("auth.html")

      _ ->
        IO.inspect("we have a user_id")
        conn
    end
  end

  def refresh_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn

      _ ->
        conn
        |> configure_session(renew: true)
    end
  end

  def current_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> assign(:current_user, nil)
        |> assign(:has_user, Accounts.has_user?())

      user_id ->
        user = Accounts.get_user(user_id)

        conn
        |> assign(:current_user, user)
    end
  end
end
