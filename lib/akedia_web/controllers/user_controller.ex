defmodule AkediaWeb.UserController do
  use AkediaWeb, :controller

  alias Akedia.{Accounts, Repo, Auth}

  def new(conn, _params) do
    changeset = Accounts.change_user(%Accounts.User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"credential" => credential_params} = user_params}) do
    case Accounts.count_users() do
      0 ->
        case Accounts.create_user(user_params) do
          {:ok, user} ->
            user
            |> Ecto.build_assoc(:credential)
            |> Accounts.change_credential(credential_params)
            |> Repo.insert!()

            conn
            |> Auth.login(user)
            |> put_flash(:info, "Welcome #{user.name}.")
            |> redirect(to: Routes.public_path(conn, :index))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      _ ->
      conn
      |> put_view(ErrorView)
      |> render("register.html")
    end
  end

  def show(conn, _params) do
    user = Accounts.get_user!()
    render(conn, "show.html", user: user)
  end

  def edit(conn, _params) do
    user = Accounts.get_user!()
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => %{"credential" => credential_params} = user_params}) do
    user = Accounts.get_user!()

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        credential = Accounts.get_credential_by_user(user.id)
        Accounts.update_credential(credential, credential_params)

        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
