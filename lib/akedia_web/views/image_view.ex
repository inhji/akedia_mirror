defmodule AkediaWeb.ImageView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Photos", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.image.text, assigns)]
  end
end
