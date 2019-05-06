defmodule AkediaWeb.Helpers.User do
  def gravatar_url(email), do: gravatar_url(email, 80)

  def gravatar_url(email, size) do
    md5_email = :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
    "https://gravatar.com/avatar/#{md5_email}?size=#{size}"
  end

  def logged_in?(%{assigns: %{current_user: current_user}} = _conn) do
    !!current_user
  end
end
