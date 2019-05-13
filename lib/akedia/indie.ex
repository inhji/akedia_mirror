defmodule Akedia.Indie do
  @moduledoc """
  The Indie context.
  """

  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Indie.Syndication

  def list_syndications do
    Repo.all(Syndication)
  end

  def get_syndication!(id), do: Repo.get!(Syndication, id)

  def get_syndication_by_type(entity_id, type) do
    Repo.get_by(Syndication, entity_id: entity_id, type: type)
  end

  def create_or_update_syndication(attrs \\ %{}) do
    case get_syndication_by_type(attrs[:entity_id], attrs[:type]) do
      nil -> create_syndication(attrs)
      syndication -> update_syndication(syndication, attrs)
    end
  end

  def create_syndication(attrs \\ %{}) do
    %Syndication{}
    |> Syndication.changeset(attrs)
    |> Repo.insert()
  end

  def update_syndication(%Syndication{} = syndication, attrs) do
    syndication
    |> Syndication.changeset(attrs)
    |> Repo.update()
  end

  def delete_syndication(%Syndication{} = syndication) do
    Repo.delete(syndication)
  end

  def change_syndication(%Syndication{} = syndication) do
    Syndication.changeset(syndication, %{})
  end
end
