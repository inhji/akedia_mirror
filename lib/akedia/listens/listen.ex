defmodule Akedia.Listens.Listen do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Listens.{Artist, Album}

  schema "listens" do
    field :track, :string
    field :listened_at, :utc_datetime

    belongs_to(:artist, Artist)
    belongs_to(:album, Album)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(listen, attrs) do
    listen
    |> cast(attrs, [:track, :listened_at, :artist_id, :album_id])
    |> validate_required([:track, :listened_at, :artist_id, :album_id])
    |> unique_constraint(:listened_at)
  end
end
