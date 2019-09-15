defmodule AkediaWeb.ArtistView do
  use AkediaWeb, :view

  def render("meta.show.html", assigns) do
    [title(assigns.artist.name, assigns)]
  end

  def listen_count(list) do
    Enum.count(list)
  end

  def listen_string(list) do
    Enum.join(list, ",")
  end

  def listen_average(list) do
    Enum.reduce([1, 2, 3], &+/2) / Enum.count(list)
  end
end
