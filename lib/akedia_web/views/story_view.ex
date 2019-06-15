defmodule AkediaWeb.StoryView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Stories", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.story.title, assigns)]
  end

  def render("scripts.edit.html", assigns), do: AkediaWeb.Helpers.Meta.admin_scripts(assigns)
  def render("scripts.new.html", assigns), do: AkediaWeb.Helpers.Meta.admin_scripts(assigns)

  def intro_style(story) do
    image_style = case Enum.empty?(story.entity.images) do
      false -> "background-image: url('#{image_url(List.first(story.entity.images), :original)}')"
      true -> ""
    end

    published_style = case story.entity.is_published do
      false -> "-webkit-filter: grayscale(100%); grayscale(100%);"
      true -> ""
    end

    Enum.join([image_style, published_style], "; ")
  end

  def intro_class(story) do
    gradient_class = case Enum.empty?(story.entity.images) do
      true -> "bg-gradient-primary"
      false -> ""
    end

    Enum.join([gradient_class], " ")
  end
end
