defmodule Akedia.Indie.Microsub.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  schema "channels" do
    field :name, :string
    field :uid, :string

    has_many :feeds, Akedia.Indie.Microsub.Feed

    timestamps()
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:name, :uid])
    |> validate_required([:name, :uid])
  end
end
