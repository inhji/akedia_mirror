defmodule Akedia.Content.Entity do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Topic, Bookmark, Page, Story}

  schema "entities" do
    field :is_pinned, :boolean, default: false
    field :is_published, :boolean, default: false
    many_to_many(:topics, Topic, join_through: "entity_topics")
    has_one :bookmark, Bookmark
    has_one :page, Page
    has_one :story, Story

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:is_published, :is_pinned])
    |> validate_required([:is_published, :is_pinned])
  end
end
