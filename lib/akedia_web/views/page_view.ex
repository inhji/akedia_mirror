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
end
