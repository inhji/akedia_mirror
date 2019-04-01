defmodule Akedia.Content.Story do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity, TitleSlug}

  schema "stories" do
    field :content, :string
    field :title, :string
    field :slug, TitleSlug.Type
    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :content, :entity_id])
    |> validate_required([:title, :content])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end
end
