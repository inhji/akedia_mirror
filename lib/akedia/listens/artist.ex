defmodule Akedia.Listens.Artist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "artists" do
    field :mbid, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :mbid])
    |> validate_required([:name])
  end
end
