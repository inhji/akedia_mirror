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

  def intro_style(story) do
    case Enum.empty?(story.entity.images) do
      false -> "background-image: url('#{image_url(List.first(story.entity.images), :original)}')"
      true -> ""
    end
  end

  def intro_class(story) do
    case Enum.empty?(story.entity.images) do
      true -> "bg-gradient-primary"
      false -> ""
    end
  end
end
