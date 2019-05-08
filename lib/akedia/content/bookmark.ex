defmodule Akedia.Content.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity}
  alias Akedia.Media.Favicon
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "bookmarks" do
    field :content, :string
    field :title, :string
    field :url, :string
    field :slug, :string
    belongs_to :entity, Entity
    belongs_to :favicon, Favicon

    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:title, :slug, :url, :content, :entity_id, :favicon_id])
    |> validate_required([:url, :title])
    |> Slug.maybe_generate_slug()
  end
end
