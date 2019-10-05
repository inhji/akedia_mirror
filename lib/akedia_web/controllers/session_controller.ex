defmodule AkediaWeb.SessionController do
  use AkediaWeb, :controller
  alias Akedia.{Accounts, Auth}
  require Logger

  @preauth_flag :authorized_for_two_factor

  def new(conn, _params) do
    changeset = Accounts.change_credential(%Accounts.Credential{})

    conn
    |> delete_session(:authorized_for_two_factor)
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"credential" => %{"email" => email, "password" => password}}) do
    case Auth.authenticate_user(email, password) do
      {:ok, user} ->
        if user.credential.public_key do
          conn
          |> put_session(@preauth_flag, true)
          |> redirect(to: Routes.session_path(conn, :two_factor))
        else
          conn
          |> Auth.login(user)
          |> redirect(to: Routes.admin_path(conn, :index))
        end

      # === DEVDOOR ===
      # conn
      # |> Auth.login(user)
      # |> redirect(to: Routes.admin_path(conn, :index))

      {:error, reason} ->
        changeset = Accounts.change_credential(%Accounts.Credential{email: email})

        conn
        |> put_flash(:error, reason)
        |> render("new.html", changeset: changeset)
    end
  end

  def two_factor(conn, _params) do
    case get_session(conn, @preauth_flag) do
      true ->
        conn
        |> delete_session(@preauth_flag)
        |> render("two_factor.html")

      _ ->
        Logger.info("Preauth Flag not found, redirecting..")

        conn
        |> put_flash(:error, "BRUH")
        |> redirect(to: Routes.public_path(conn, :index))
    end

    # DEV ONLY
    # render(conn,  "two_factor.html")
  end

  def webauthn_create(conn, _params) do
    user = Accounts.get_user!()
    public_key = user.credential.external_id
    credential_options = WebAuthnEx.credential_request_options()

    conn = put_session(conn, :challenge, credential_options.challenge)

    credential_options =
      credential_options
      |> Map.put(:allowCredentials, [%{id: public_key, type: "public-key"}])
      |> Map.put(:challenge, Base.encode64(credential_options.challenge))

    json(conn, credential_options)
  end

  def webauthn_callback(conn, %{"id" => id, "response" => response}) do
    {:ok, authenticator_data} = response["authenticatorData"] |> Base.decode64()
    {:ok, client_data_json} = response["clientDataJSON"] |> Base.decode64()
    {:ok, signature} = response["signature"] |> Base.decode64()

    challenge = get_session(conn, :challenge)
    user = Accounts.get_user!()

    allowed_credentials = [
      %{
        id: Base.decode64!(user.credential.external_id),
        public_key: Base.decode64!(user.credential.public_key)
      }
    ]

    result =
      WebAuthnEx.AuthAssertionResponse.new(
        id |> Base.decode64!(),
        authenticator_data,
        signature,
        challenge,
        Akedia.url(),
        allowed_credentials,
        nil,
        client_data_json
      )

    conn =
      case result do
        {:ok, _} ->
          conn
          |> Auth.login(user)
          |> put_status(:ok)

        {:error, _reason} ->
          conn |> put_status(403)
      end

    json(conn, %{})
  end

  def totp_create(conn, %{"totp" => totp}) do
    user = Accounts.get_user!()

    secret =
      Akedia.Settings.get(:totp_secret)
      |> Base.encode32()

    case Totpex.validate_totp(secret, totp, grace_periods: 1) do
      true ->
        conn
        |> Auth.login(user)
        |> redirect(to: Routes.public_path(conn, :index))

      false ->
        conn
        |> put_flash(:error, "BRUH")
        |> render("two_factor.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.logout()
    |> redirect(to: Routes.public_path(conn, :index))
  end
end
