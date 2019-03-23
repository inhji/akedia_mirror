defmodule Akedia.Content.EntityTopic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.{Entity, Topic}

  schema "entity_topics" do
    belongs_to :entity, Entity
    belongs_to :topic, Topic

    timestamps()
  end

  @doc false
  def changeset(entity_topic, attrs) do
    entity_topic
    |> cast(attrs, [:entity_id, :topic_id])
    |> validate_required([])
  end
end
