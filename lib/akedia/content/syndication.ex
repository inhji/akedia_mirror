defmodule Akedia.Content.Syndication do
  use Ecto.Schema
  import Ecto.Changeset

  schema "syndications" do
    field :type, :string
    field :url, :string
    field :entity_id, :id

    timestamps()
  end

  @doc false
  def changeset(syndication, attrs) do
    syndication
    |> cast(attrs, [:type, :url, :entity_id])
    |> validate_required([:type, :entity_id])
  end
end
