defmodule AkediaWeb.SearchView do
  use AkediaWeb, :view

  def render("meta.search.html", _assigns) do
    ~E{
      <title>Suche · Akedia</title>
    }
  end
end
