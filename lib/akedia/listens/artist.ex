defmodule Akedia.Listens.Artist do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Media.ArtistimageUploader

  schema "artists" do
    field :mbid, :string
    field :name, :string
    field :image, ArtistimageUploader.Type

    has_many :listens, Akedia.Listens.Listen

    timestamps()
  end

  @doc false
  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name, :mbid])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
