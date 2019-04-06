defmodule AkediaWeb.StoryView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Geschichten · Akedia</title>
    }
  end

  def render("meta.show.html", assigns) do
    ~E{
      <title><%= @story.title %> · Akedia</title>
    }
  end
end
