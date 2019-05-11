defmodule Akedia do
  @moduledoc """
  Akedia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Akedia.Content.{Bookmark, Like, Story, Page, Post}
  alias AkediaWeb.Router.Helpers, as: Routes
  alias AkediaWeb.Endpoint

  def url do
    Endpoint
    |> Routes.url()
    |> URI.parse()
    |> to_string()
    |> String.trim_trailing("/")
  end

  def url(%Like{} = like), do: Routes.like_url(Endpoint, :show, like)
  def url(%Bookmark{} = bookmark), do: Routes.bookmark_url(Endpoint, :show, bookmark)
  def url(%Story{} = story), do: Routes.story_url(Endpoint, :show, story)
  def url(%Page{} = page), do: Routes.page_url(Endpoint, :show, page)
  def url(%Post{} = post), do: Routes.post_url(Endpoint, :show, post)
end
