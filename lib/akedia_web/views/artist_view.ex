defmodule AkediaWeb.ArtistView do
  use AkediaWeb, :view

  def render("meta.show.html", assigns) do
    [title(assigns.artist.name, assigns)]
  end
end
