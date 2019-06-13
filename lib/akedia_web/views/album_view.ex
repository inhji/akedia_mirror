defmodule AkediaWeb.AlbumView do
  use AkediaWeb, :view

  def render("meta.show.html", assigns) do
    [title(assigns.album.name, assigns)]
  end

  def render("meta.edit.html", assigns) do
    [title(assigns.album.name, assigns)]
  end

  def musicbrainz_query_url(album) do
    artist = album.artist.name
    |> URI.encode_www_form()
    |> String.downcase()
    "https://musicbrainz.org/search?query=#{artist}&type=artist&method=indexed"
  end
end