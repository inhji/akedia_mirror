defmodule Akedia.Auth.AuthErrorHandler do
  import Phoenix.Controller, only: [render: 2, put_layout: 2, put_view: 2]
  alias AkediaWeb.{ErrorView, LayoutView}

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_layout({LayoutView, "app.html"})
    |> put_view(ErrorView)
    |> render("auth.html")
  end
end
