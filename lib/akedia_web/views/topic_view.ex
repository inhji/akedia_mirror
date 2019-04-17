defmodule AkediaWeb.TopicView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Themen · Akedia</title>
    }
  end

  def render("meta.tagged.html", assigns) do
    ~E{
      <title>Thema <%= @topic.text %> · Akedia</title>
    }
  end
end
