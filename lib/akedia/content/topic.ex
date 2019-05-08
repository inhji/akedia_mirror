defmodule Akedia.Content.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "topics" do
    field :text, :string
    field :slug, :string

    many_to_many(:entities, Entity, join_through: "entity_topics")

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> Slug.maybe_generate_slug(add_random: false)
    |> unique_constraint(:slug)
  end
end
