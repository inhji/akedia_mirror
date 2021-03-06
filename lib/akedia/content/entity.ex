defmodule Akedia.Content.Entity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Topic, Bookmark, Like, Post}
  alias Akedia.Media.Image
  alias Akedia.Content.Syndication

  schema "entities" do
    field :is_pinned, :boolean, default: false
    field :is_published, :boolean, default: false

    field :bridgy_fed, :boolean, default: false

    many_to_many(:topics, Topic, join_through: "entity_topics")

    has_one :bookmark, Bookmark
    has_one :like, Like
    has_one :post, Post
    has_one :image, Image

    has_many :syndications, Syndication
    has_many :mentions, Akedia.Webmentions.Mention
    has_one :context, Akedia.Indie.Context

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:is_published, :is_pinned, :bridgy_fed])
    |> validate_required([:is_published, :is_pinned, :bridgy_fed])
  end
end
