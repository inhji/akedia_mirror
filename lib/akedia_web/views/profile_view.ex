defmodule AkediaWeb.ProfileView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Profiles", assigns)]
  end

  def render("meta.edit.html", assigns) do
    [title("Edit '#{assigns.profile.name}'", assigns)]
  end

  def visibility(profile) do
    case profile.public do
      true -> "public"
      _ -> "private"
    end
  end
end
