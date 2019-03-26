defmodule AkediaWeb.Helpers.Media do
  def image_url(image, version) do
    Akedia.Media.ImageUploader.url({image.name, image}, version)
  end

  def image_url(image) do
    image_url(image, :thumb)
  end
end
