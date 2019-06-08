defmodule AkediaWeb.TopicView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Tags", assigns)]
  end

  def render("meta.tagged.html", assigns) do
    [title("Tagged with #{assigns.topic.text}", assigns)]
  end
end
