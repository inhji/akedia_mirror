defmodule AkediaWeb.PageView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Wiki · Akedia</title>
    }
  end

  def render("meta.show.html", assigns) do
    ~E{
      <title><%= @page.title %> · Akedia</title>
    }
  end

  def pinned_class(page) do
    case page.entity.is_pinned do
      true -> "pinned"
      false -> ""
    end
  end
end
