defmodule Akedia.Indie do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Indie.{Author, Context}

  def config(key, default) do
    config = Application.get_env(:akedia, Akedia.Indie)
    Keyword.get(config, key, default)
  end

  def list_authors do
    Author
    |> Repo.all()
    |> Repo.preload([:author, :entity])
  end

  def get_author!(id) do
    Author
    |> Repo.get!(id)
  end

  def get_author_by_url(url) do
    Author |> Repo.get_by(url: url)
  end

  def create_author(attrs \\ %{}) do
    IO.inspect("create_author")
    IO.inspect(attrs)

    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_author(%{url: url} = author) do
    IO.inspect("maybe_create_author")
    IO.inspect(author)

    author =
      if url == "" do
        Map.put(author, :url, "https://example.com")
      else
        author
      end

    case get_author_by_url(url) do
      nil ->
        case create_author(author) do
          {:ok, author} -> {:ok, author}
          {:error, error} -> {:error, error}
        end

      author ->
        {:ok, author}
    end
  end

  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  def delete_author(%Author{} = author) do
    author
    |> Repo.delete()
  end

  def get_context!(id) do
    Context
    |> Repo.get!(id)
  end

  def get_context_by_url(url) do
    Context |> Repo.get_by(url: url)
  end

  def create_context(attrs \\ %{}) do
    %Context{}
    |> Context.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_create_context(%{url: url} = context) do
    case get_context_by_url(url) do
      nil ->
        case create_context(context) do
          {:ok, context} ->
            {:ok, context}

          {:error, error} ->
            {:error, error}
        end

      context ->
        {:ok, context}
    end
  end

  def update_context(%Context{} = context, attrs) do
    context
    |> Context.changeset(attrs)
    |> Repo.update()
  end

  def delete_context(%Context{} = context) do
    Repo.delete(context)
  end
end
