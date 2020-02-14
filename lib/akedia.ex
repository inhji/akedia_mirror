defmodule Akedia do
  @moduledoc """
  Akedia is the main Module and keeps some general helpers.
  """
  alias Akedia.Content.{Bookmark, Like, Post}
  alias AkediaWeb.Router.Helpers, as: Routes
  alias AkediaWeb.Endpoint

  @url_types_regex ~r/\/(?<type>bookmarks|posts|likes)\/(?<slug>[\w\d-]*)\/?$/
  @type entity :: %Akedia.Content.Post{} | %Akedia.Content.Like{} | %Akedia.Content.Bookmark{}
  @user_agent {"User-Agent", "Akedia/0.x (https://inhji.de)"}

  @spec user_agent() :: {String.t(), String.t()}
  @spec url() :: String.t()
  @spec url(String.t()) :: String.t()
  @spec domain() :: String.t()
  @spec entity_from_url(String.t()) :: {:ok, entity} | {:error, nil}
  @spec entity_url(entity) :: String.t()

  @doc """
  Returns the custom useragent.
  """
  def user_agent(), do: @user_agent

  @doc """
  Returns the absolute url of the site with the trailing slash removed.

  ## Examples

      iex> Akedia.url()
      "http://localhost:4000"

  """
  def url(), do: url("")

  @doc """
  Returns the absolute url of the supplied path with the trailing slash removed.

  ## Examples

      iex> Akedia.url("/some-path")
      "http://localhost:4000/some-path"

  """
  def url(path) when is_binary(path) do
    Endpoint
    |> Routes.url()
    |> URI.merge(path)
    |> to_string()
    |> String.trim_trailing("/")
  end

  @doc """
  Returns the domain, including port, of the site.

  ## Examples

      iex> Akedia.domain()
      "localhost:4000"

  """
  def domain() do
    Endpoint
    |> Routes.url()
    |> URI.parse()
    |> Map.get(:authority)
  end

  @doc """
  Returns the absolute url to the supplied post

  ## Example

      iex> Akedia.entity_url(%Post{})
      "localhost:4000/posts/example-post"

  """
  def entity_url(schema) when is_map(schema), do: do_entity_url(schema)

  defp do_entity_url(%Like{} = like), do: Routes.like_url(Endpoint, :show, like)
  defp do_entity_url(%Bookmark{} = bookmark), do: Routes.bookmark_url(Endpoint, :show, bookmark)
  defp do_entity_url(%Post{} = post), do: Routes.post_url(Endpoint, :show, post)

  @doc """
  Returns a Struct from the given url

  ## Example

      iex> Akedia.entity_by_url("localhost:4000/posts/example-post")
      %Post{}

  """
  def entity_from_url(url) do
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
