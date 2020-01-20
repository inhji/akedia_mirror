defmodule Akedia.Mentions do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Mentions.Mention

  def list_mentions do
    Mention
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload([:author, :entity])
  end

  def get_mention!(id) do
    Mention
    |> Repo.get!(id)
  end

  def get_mention(source, target) do
    Mention
    |> Repo.get_by(source: source, target: target)
  end

  def create_mention(attrs \\ %{}) do
    %Mention{}
    |> Mention.changeset(attrs)
    |> Repo.insert()
  end

  def update_mention(%Mention{} = mention, attrs \\ %{}) do
    mention
    |> Mention.changeset(attrs)
    |> Repo.update()
  end

  def delete_mention(%Mention{} = mention) do
    mention
    |> Repo.delete()
  end

  def create_or_update_mention(%{:source => source, :target => target} = attrs) do
    case get_mention(source, target) do
      nil -> create_mention(attrs)
      mention -> update_mention(mention, attrs)
    end
  end
end
