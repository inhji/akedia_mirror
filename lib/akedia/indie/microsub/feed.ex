defmodule Akedia.Indie.Microsub.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :url, :string
    field :title, :string
    field :description, :string

    belongs_to :channel, Akedia.Indie.Microsub.Channel
    has_many :entries, Akedia.Indie.Microsub.FeedEntry

    timestamps()
  end

  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:url, :title, :description, :channel_id])
    |> validate_required([:url, :channel_id])
  end
end
