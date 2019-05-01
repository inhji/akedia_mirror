defmodule Akedia.Content.Listen do
  use Ecto.Schema
  import Ecto.Changeset

  schema "listens" do
    field :album, :string
    field :artist, :string
    field :track, :string
    field :listened_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(listen, attrs) do
    listen
    |> cast(attrs, [:track, :artist, :album, :listened_at])
    |> validate_required([:track, :artist, :album, :listened_at])
    |> unique_constraint(:listened_at)
  end
end
