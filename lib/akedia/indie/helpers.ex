defmodule Akedia.Indie.Helpers do
  @url_types_regex ~r/\/(?<type>bookmarks|posts|likes)\/(?<slug>[\w\d-]*)\/?$/

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
