defmodule Akedia.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "posts" do
    field :content, :string
    field :content_html, :string
    field :content_sanitized, :string

    field :slug, :string
    field :title, :string

    field :reply_to, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :slug, :reply_to, :entity_id])
    |> validate_required([:content])
    |> maybe_update_html()
    |> maybe_update_sanitized()
    |> Slug.maybe_generate_slug()
    |> unique_constraint(:slug)
  end

  def maybe_update_html(changeset) do
    IO.inspect(changeset)

    case get_change(changeset, :content) do
      nil ->
        changeset

      value ->
        {:safe, html} = AkediaWeb.Markdown.to_html(value)
        put_change(changeset, :content_html, html)
    end
  end

  def maybe_update_sanitized(changeset) do
    IO.inspect(changeset)

    case get_change(changeset, :content_html) do
      nil ->
        changeset

      value ->
        sanitized = HtmlSanitizeEx.strip_tags(value)
        put_change(changeset, :content_sanitized, sanitized)
    end
  end
end
