defmodule AkediaWeb.SessionController do
  use AkediaWeb, :controller
  alias Akedia.{Accounts, Auth}

  def new(conn, _params) do
    changeset = Accounts.change_credential(%Accounts.Credential{})
    referer = case get_req_header(conn, "referer") do
      [referer] -> referer
      _ -> nil
    end

    conn
    |> Plug.Conn.put_session(:referer, referer)
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"credential" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->

        redirect_path =
          case conn |> get_session(:referer) do
            nil -> Routes.user_path(conn, :show)
            referer -> URI.parse(referer).path
          end

        conn
        |> Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}")
        |> delete_session(:referer)
        |> redirect(to: redirect_path)
      {:error, reason} ->
        changeset = Accounts.change_credential(%Accounts.Credential{email: email})

        conn
        |> put_flash(:error, reason)
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.public_path(conn, :index))
  end
end
