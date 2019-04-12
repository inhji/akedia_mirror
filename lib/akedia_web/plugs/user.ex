defmodule AkediaWeb.Plugs.User do
  import Plug.Conn, only: [assign: 3]
  alias Akedia.Accounts

  def assign_profiles(conn, _) do
    case Accounts.get_user!() do
      nil ->
        conn
      user ->
        conn
        |> assign(:user_profiles, user.profiles)

    end
  end
end
