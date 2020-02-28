defmodule AkediaWeb.QueueController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def drafts(conn, _params) do
    drafts = Akedia.Content.list_drafted_posts()

    render(conn, "drafts.html", posts: drafts)
  end
end
