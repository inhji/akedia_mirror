defmodule Akedia.Content.Topic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity

  schema "topics" do
    field :text, :string
    many_to_many(:entities, Entity, join_through: "entity_topics")

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> update_change(:text, &String.downcase/1)
    |> unique_constraint(:text)
  end
end
