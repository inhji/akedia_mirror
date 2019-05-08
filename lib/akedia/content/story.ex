defmodule Akedia.Content.Story do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity}
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "stories" do
    field :content, :string
    field :title, :string
    field :slug, :string
    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :content, :entity_id])
    |> validate_required([:title, :content])
    |> Slug.maybe_generate_slug()
  end
end
