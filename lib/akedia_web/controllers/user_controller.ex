defmodule AkediaWeb.UserController do
  use AkediaWeb, :controller

  alias Akedia.{Accounts, Repo, Auth}
  alias Akedia.Accounts.User
  import Akedia.Helpers, only: [with_context: 1]

  def new(conn, _params) do
    changeset = Accounts.change_user(%Accounts.User{})

    conn
    |> put_layout("bare.html")
    |> render("new.html", changeset: changeset)
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

  def show(%{private: %{plug_format: "html"}} = conn, _params) do
    user = Accounts.get_user!()
    render(conn, "show.html", user: user)
  end

  def show(%{private: %{plug_format: "json" <> _rest}} = conn, _params) do
    user = Accounts.get_user!()
    json = User.to_json(user)
    json(conn, with_context(json))
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

  def security(conn, _params) do
    user = Akedia.Accounts.get_user!()
    issuer = user.username
    email = user.credential.email

    qr_code =
      Akedia.Settings.get(:totp_secret)
      |> Base.encode32()
      |> totp_qr_string(issuer, email)
      |> QRCode.QR.create!()
      |> QRCode.Svg.to_base64()

    render(conn, "security.html", qr_code: qr_code)
  end

  defp totp_qr_string(secret, issuer, email) do
    "otpauth://totp/#{issuer}:#{email}?secret=#{secret}&issuer=#{issuer}&algorithm=SHA1&digits=6&period=30"
  end
end
