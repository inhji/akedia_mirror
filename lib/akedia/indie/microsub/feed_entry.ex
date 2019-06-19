defmodule Akedia.Indie.Microsub.FeedEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_entries" do
    field :author, :string
    field :summary, :string
    field :title, :string
    field :url, :string
    field :published_at, :utc_datetime

    field :is_read, :boolean, default: false

    belongs_to :feed, Akedia.Indie.Microsub.Feed

    timestamps()
  end

  @doc false
  def changeset(feed_entry, attrs) do
    feed_entry
    |> cast(attrs, [:title, :summary, :author, :url, :feed_id, :published_at, :is_read])
    |> validate_required([:title, :summary, :author, :url, :feed_id, :published_at, :is_read])
    |> unique_constraint(:url)
  end
end
