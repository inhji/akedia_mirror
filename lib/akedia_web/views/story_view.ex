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
end
