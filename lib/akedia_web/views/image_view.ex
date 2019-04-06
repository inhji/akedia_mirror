defmodule AkediaWeb.ImageView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Bilder · Akedia</title>
    }
  end

  def render("meta.show.html", assigns) do
    ~E{
      <title><%= @image.text %> · Akedia</title>
    }
  end
end
