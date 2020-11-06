defmodule AkediaWeb.MentionController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    mentions = Akedia.Mentions.list_mentions()

    render(conn, "index.html", mentions: mentions)
  end
end
