defmodule Akedia.Content.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity}
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "pages" do
    field :content, :string
    field :slug, :string
    field :title, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:title, :slug, :content, :entity_id])
    |> validate_required([:title, :content])
    |> Slug.maybe_generate_slug()
  end
end
