defmodule AkediaWeb.TopicView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Topics</title>
    }
  end

  def render("meta.tagged.html", assigns) do
    ~E{
      <title>Topic <%= @topic.text %></title>
    }
  end
end
