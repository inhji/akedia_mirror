defmodule Akedia.Content.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "topics" do
    field :text, :string
    field :slug, :string
    field :description, :string
    field :icon, :string
    field :is_pinned, :boolean, default: true
    field :entity_count, :integer, virtual: true

    many_to_many(:entities, Entity, join_through: "entity_topics")

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:text, :description, :icon, :is_pinned])
    |> validate_required([:text])
    |> Slug.maybe_generate_slug(add_random: false)
    |> unique_constraint(:slug)
  end
end
