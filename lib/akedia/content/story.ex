defmodule Akedia.Content.Story do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity

  schema "stories" do
    field :content, :string
    field :slug, :string
    field :title, :string
    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :slug, :content, :entity_id])
    |> validate_required([:title, :slug, :content])
  end
end
