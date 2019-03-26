defmodule Akedia.Media.EntityImages do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entity_images" do
    field :image_id, :id
    field :entity_id, :id

    timestamps()
  end

  @doc false
  def changeset(entity_images, attrs) do
    entity_images
    |> cast(attrs, [])
    |> validate_required([])
  end
end
