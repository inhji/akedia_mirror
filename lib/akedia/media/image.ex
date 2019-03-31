defmodule Akedia.Media.Image do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity

  schema "images" do
    field :name, Akedia.Media.ImageUploader.Type
    field :text, :string
    field :path, :string

    many_to_many(:entities, Entity, join_through: "entity_images")

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:text, :path])
    |> cast_attachments(attrs, [:name])
    |> validate_required([:name, :text, :path])
  end
end
