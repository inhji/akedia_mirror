defmodule AkediaWeb.Helpers.User do
  def gravatar_url(email) do
    md5_email = :crypto.hash(:md5, email) |> Base.encode16(case: :lower)
    "https://gravatar.com/avatar/" <> md5_email
  end
end
