defmodule Akedia.Media.Image do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity

  schema "images" do
    field :name, Akedia.Media.ImageUploader.Type
    field :text, :string
    field :path, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:text, :path, :entity_id])
    |> cast_attachments(attrs, [:name], allow_paths: true)
    |> validate_required([:name, :entity_id, :path])
  end
end
