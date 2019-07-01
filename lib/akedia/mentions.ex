defmodule Akedia.Mentions do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Mentions.{Mention, Author}

  def list_mentions do
    Mention
    |> Repo.all()
    |> Repo.preload([:author, :entity])
  end

  def get_mention!(id) do
    Mention
    |> Repo.get!(id)
  end

  def create_mention(attrs \\ %{}) do
    %Mention{}
    |> Mention.changeset(attrs)
    |> Repo.insert()
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
    Author
    |> Repo.get_by(url: url)
  end

  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end
end
