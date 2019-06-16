defmodule Akedia.Indie.Microsub.FeedEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_entries" do
    field :author, :string
    field :summary, :string
    field :title, :string
    field :url, :string

    belongs_to :feed, Akedia.Indie.Microsub.Feed

    timestamps()
  end

  @doc false
  def changeset(feed_entry, attrs) do
    feed_entry
    |> cast(attrs, [:title, :summary, :author, :url, :feed_id])
    |> validate_required([:title, :summary, :author, :url, :feed_id])
    |> unique_constraint(:url)
  end
end