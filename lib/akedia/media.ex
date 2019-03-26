defmodule Akedia.Media do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Media.{Image, ImageUploader}

  def list_images do
    Repo.all(Image)
  end

  def get_image!(id), do: Repo.get!(Image, id)

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
    ImageUploader.delete({image.name, image})
    File.rmdir(ImageUploader.base_path() <> image.path)
    Repo.delete(image)
  end

  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end
end
