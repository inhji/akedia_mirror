defmodule AkediaWeb.AtomController do
  use AkediaWeb, :controller
  alias Atomex.{Feed, Entry}
  alias AkediaWeb.Router.Helpers, as: Routes

  @content_type "application/atom+xml"

  def index(conn, _params) do
    user = Akedia.Accounts.get_user!()

    feed =
      Akedia.Content.list_entities()
      |> build_feed(conn, user)

    conn
    |> put_resp_header("Content-Type", @content_type)
    |> send_resp(200, feed)
  end

  def build_feed(entities, conn, user) do
    entries =
      entities
      |> Enum.map(&build_entry(&1, user))
      |> Enum.filter(fn e -> !!e end)

    Feed.new(Akedia.url(), DateTime.utc_now(), "Inhji.de Homepage Feed")
    |> Feed.author(user.name, email: user.credential.email)
    |> Feed.link(Routes.atom_url(conn, :index), rel: "self", type: @content_type)
    |> Feed.link("https://inhji.superfeedr.com", rel: "hub")
    |> Feed.generator()
    |> Feed.entries(entries)
    |> Feed.build()
    |> Atomex.generate_document()
  end

  def build_entry(%{:like => like} = _entity, user) when not is_nil(like) do
    Entry.new(Akedia.url(like), convert_date(like.inserted_at), "Like of #{like.url}")
    |> Entry.author(user.name, uri: Akedia.url())
    |> Entry.content("<p>Like of #{like.url}</p>", type: "html")
    |> Entry.build()
  end

  def build_entry(%{:post => post} = _entity, user) when not is_nil(post) do
    Entry.new(Akedia.url(post), convert_date(post.inserted_at), post.title)
    |> Entry.author(user.name, uri: Akedia.url())
    |> Entry.content(AkediaWeb.Markdown.to_html!(post.content), type: "html")
    |> Entry.build()
  end

  def build_entry(%{:bookmark => bookmark} = _entity, user) when not is_nil(bookmark) do
    Entry.new(Akedia.url(bookmark), convert_date(bookmark.inserted_at), bookmark.title)
    |> Entry.author(user.name, uri: Akedia.url())
    |> Entry.content(AkediaWeb.Markdown.to_html!(bookmark.content), type: "html")
    |> Entry.build()
  end

  def build_entry(_, _user) do
    nil
  end

  def convert_date(naive_date) do
    DateTime.from_naive!(naive_date, "Etc/UTC")
  end
end
