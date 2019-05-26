defmodule AkediaWeb.ProfileView do
  use AkediaWeb, :view

  def visibility(profile) do
    case profile.public do
      true -> "public"
      _ -> "private"
    end
  end
end
