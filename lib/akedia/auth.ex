defmodule Akedia.Auth do
  alias Akedia.{Accounts, Repo}
  alias Akedia.Auth.Guardian
  import Plug.Conn

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
    |> Guardian.Plug.sign_in(user)
    |> assign(:current_user, user)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
  end
end
