defmodule Akedia do
  @moduledoc """
  > „Der Dämon der Trägheit, der auch Mittagsdämon genannt wird, ist belastender als alle anderen Dämonen.“

  Akedia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Akedia.Content.{Bookmark, Like, Story, Page, Post}
  alias AkediaWeb.Router.Helpers, as: Routes
  alias AkediaWeb.Endpoint

  @doc """
  Returns the absolute url of the site.
  """
  def url() do
    Endpoint
    |> Routes.url()
    |> URI.parse()
    |> to_string()
    |> String.trim_trailing("/")
  end

  @doc """
  Returns the absolute url to the supplied post
  """
  def url(schema), do: do_url(schema)

  defp do_url(%Like{} = like), do: Routes.like_url(Endpoint, :show, like)
  defp do_url(%Bookmark{} = bookmark), do: Routes.bookmark_url(Endpoint, :show, bookmark)
  defp do_url(%Story{} = story), do: Routes.story_url(Endpoint, :show, story)
  defp do_url(%Page{} = page), do: Routes.page_url(Endpoint, :show, page)
  defp do_url(%Post{} = post), do: Routes.post_url(Endpoint, :show, post)
end
