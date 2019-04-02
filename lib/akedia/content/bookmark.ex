defmodule Akedia.Content.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity, TitleSlug}

  @derive {Phoenix.Param, key: :slug}
  schema "bookmarks" do
    field :content, :string
    field :title, :string
    field :url, :string
    field :slug, TitleSlug.Type
    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:title, :slug, :url, :content, :entity_id])
    |> validate_required([:title, :url, :content])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end
end
