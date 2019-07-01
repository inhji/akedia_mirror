defmodule Akedia.Indie.Webmentions.Handler do
  @behaviour Akedia.Plugs.PlugWebmention.HandlerBehaviour
  alias Akedia.Mentions

  @impl true
  def handle_receive(%{:source => source, :target => target, :post => post} = body) do
    author = maybe_create_author(post.author)
    IO.inspect(author)

    :ok
  end

  def maybe_create_author(%{:url => url} = author) do
    case Mentions.get_author_by_url(url) do
      nil ->
        case Mentions.create_author(author) do
          {:ok, author} -> {:ok, author}
          {:error, error} -> {:error, "Bad Request"}
        end

      {:ok, author} ->
        {:ok, author}
    end
  end
end
