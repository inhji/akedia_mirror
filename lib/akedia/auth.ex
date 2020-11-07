defmodule Akedia.Auth do
  alias Akedia.{Accounts, Repo}
  import Plug.Conn
  import Plug.Conn, only: [get_session: 2, put_session: 3, configure_session: 2, assign: 3]

  @error_message "Incorrect email or password"

  def authenticate_user(email, password) do
    Accounts.get_user_by_email(email)
    |> Repo.preload(:credential)
    |> check_password(password)
  end

  defp check_password(nil, _), do: {:error, @error_message}

  defp check_password(user, password) do
    case Bcrypt.verify_pass(password, user.credential.encrypted_password) do
      true -> {:ok, user}
      false -> {:error, @error_message}
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def logged_in?(conn) do
    case get_session(conn, :user_id) do
      nil -> false
      _ -> true
    end
  end

  def handle_webauthn(id, response, challenge) do
    {:ok, authenticator_data} = response["authenticatorData"] |> Base.decode64()
    {:ok, client_data_json} = response["clientDataJSON"] |> Base.decode64()
    {:ok, signature} = response["signature"] |> Base.decode64()

    user = Accounts.get_user!()

    allowed_credentials = [
      %{
        id: Base.decode64!(user.credential.external_id),
        public_key: Base.decode64!(user.credential.public_key)
      }
    ]

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
  end
end
