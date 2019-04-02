defmodule Akedia.Content.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity, TitleSlug}

  @derive {Phoenix.Param, key: :slug}
  schema "pages" do
    field :content, :string
    field :slug, TitleSlug.Type
    field :title, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :slug, :content, :entity_id])
    |> validate_required([:title, :content])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end
end
