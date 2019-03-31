defmodule Akedia.Media do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Media.{Image, ImageUploader, EntityImage}

  def list_images do
    list(Image, desc: :inserted_at)
  end

  def get_image!(id), do: Repo.get!(Image, id) |> Repo.preload(:entities)

  def create_image(attrs \\ %{}) do
    %Image{path: Ecto.UUID.generate()}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  def delete_image(%Image{} = image) do
    # Delete the files, the containing directory and the db record
    Repo.delete(image)
    ImageUploader.delete({image.name, image})
    File.rmdir(ImageUploader.base_path() <> image.path)
  end

  # Image Assoc Helpers

  def add_image(%{entity_id: entity_id}, image_id) when is_binary(image_id) do
    add_image(entity_id, Integer.parse(image_id))
  end

  def add_image(%{entity_id: entity_id}, image_id) do
    add_image(entity_id, image_id)
  end

  def add_image(entity_id, image_id) do
    %EntityImage{}
    |> EntityImage.changeset(%{image_id: image_id, entity_id: entity_id})
    |> Repo.insert()
  end

  def add_images(content, image_ids) when is_binary(image_ids) do
    add_images(content, split_image_ids(image_ids))
  end

  def add_images(content, image_ids) do
    Enum.each(image_ids, &add_image(content, &1))
    content
  end

  def remove_image(%{entity_id: entity_id}, image_id) do
    remove_image(entity_id, image_id)
  end

  def remove_image(entity_id, image_id) do
    case Repo.get_by(EntityImage, %{entity_id: entity_id, image_id: image_id}) do
      nil -> nil
      image -> Repo.delete(image)
    end
  end

  def remove_images(content, image_ids) do
    Enum.each(image_ids, &remove_image(content, &1))
    content
  end

  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end

  def images_loaded(%{entity: %{images: images}}) do
    images |> Enum.map_join(", ", & &1.id)
  end

  def split_image_ids(""), do: []
  def split_image_ids(image_string) do
    image_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def update_images(content, new_image_ids) do
    old_image_ids = content |> images_loaded() |> split_image_ids()
    new_image_ids = new_image_ids |> split_image_ids()

    content
    |> add_images(new_image_ids -- old_image_ids)
    |> remove_images(old_image_ids -- new_image_ids)
  end

  # Utils

  def list(schema, constraint) do
    schema
    |> order_by(^constraint)
    |> Repo.all()
    |> Repo.preload(entities: [:topics])
  end
end
