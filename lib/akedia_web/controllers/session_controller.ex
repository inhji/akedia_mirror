defmodule AkediaWeb.SessionController do
  use AkediaWeb, :controller
  alias Akedia.{Accounts, Auth}

  def new(conn, _params) do
    changeset = Accounts.change_credential(%Accounts.Credential{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"credential" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}")
        |> redirect(to: Routes.user_path(conn, :show))
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
