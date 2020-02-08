defmodule AkediaWeb.PageView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Wiki", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.page.title, assigns)]
  end

  def pinned_class(page) do
    case page.entity.is_pinned do
      true -> "pinned"
      false -> ""
    end
  end
end
