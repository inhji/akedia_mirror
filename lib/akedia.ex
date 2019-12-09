defmodule Akedia do
  @moduledoc """
  > „Der Dämon der Trägheit, der auch Mittagsdämon genannt wird, ist belastender als alle anderen Dämonen.“

  Akedia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Akedia.Content.{Bookmark, Like, Post}
  alias AkediaWeb.Router.Helpers, as: Routes
  alias AkediaWeb.Endpoint

  @url_types_regex ~r/\/(?<type>bookmarks|posts|likes)\/(?<slug>[\w\d-]*)\/?$/

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
  defp do_url(%Post{} = post), do: Routes.post_url(Endpoint, :show, post)

  @doc """
  Returns a Struct from the given url
  """
  def get_post_by_url(url) do
    case Regex.named_captures(@url_types_regex, url) do
      %{"type" => "bookmarks", "slug" => slug} ->
        {:ok, Akedia.Content.get_bookmark!(slug)}

      %{"type" => "posts", "slug" => slug} ->
        {:ok, Akedia.Content.get_post!(slug)}

      %{"type" => "likes", "slug" => id} ->
        {:ok, Akedia.Content.get_like!(id)}

      nil ->
        {:error, nil}
    end
  end
end
