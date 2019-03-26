defmodule Akedia.Media.EntityImage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entity_images" do
    field :image_id, :id
    field :entity_id, :id

    timestamps()
  end

  @doc false
  def changeset(entity_image, attrs) do
    entity_image
    |> cast(attrs, [:image_id, :entity_id])
    |> validate_required([])
  end
end
