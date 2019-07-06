defmodule AkediaWeb.TopicView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Tags", assigns)]
  end
end
