defmodule AkediaWeb.MentionController do
  use AkediaWeb, :controller

  alias Akedia.Mentions

  def index(conn, _params) do
    mentions = Mentions.list_mentions()

    render(conn, "index.html", mentions: mentions)
  end
end
