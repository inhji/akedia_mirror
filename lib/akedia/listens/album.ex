defmodule Akedia.Listens.Album do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Listens.{Artist, Listen}
  alias Akedia.Media.CoverartUploader

  schema "albums" do
    field :mbid, :string
    field :name, :string
    field :cover, CoverartUploader.Type

    belongs_to(:artist, Artist)
    has_many(:listens, Listen)

    timestamps()
  end

  @doc false
  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :mbid, :artist_id])
    |> cast_attachments(attrs, [:cover], allow_paths: true)
    |> validate_required([:name, :artist_id])
  end
end
