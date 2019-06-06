defmodule AkediaWeb.ListenView do
  use AkediaWeb, :view
  import Scrivener.HTML

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Listens · Akedia</title>
    }
  end

  def render("meta.artists.html", _assigns) do
    ~E{
      <title>Listens by Artist · Akedia</title>
    }
  end
end
