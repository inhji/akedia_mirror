defmodule Akedia.Content.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity}
  alias Akedia.Media.Favicon
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "bookmarks" do
    field :content, :string
    field :content_html, :string
    field :content_sanitized, :string
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
    |> maybe_update_html()
    |> maybe_update_sanitized()
  end

  def maybe_update_html(changeset) do
    case get_change(changeset, :content) do
      nil ->
        changeset

      value ->
        {:safe, html} = AkediaWeb.Markdown.to_html(value)
        put_change(changeset, :content_html, html)
    end
  end

  def maybe_update_sanitized(changeset) do
    case get_change(changeset, :content_html) do
      nil ->
        changeset

      value ->
        sanitized = HtmlSanitizeEx.strip_tags(value)
        put_change(changeset, :content_sanitized, sanitized)
    end
  end
end
