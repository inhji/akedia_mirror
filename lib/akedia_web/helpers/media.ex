defmodule AkediaWeb.Helpers.Media do
  use Phoenix.HTML
  alias Akedia.Media.{
    FaviconUploader,
    ImageUploader,
    CoverartUploader,
    AvatarUploader
  }

  def image_url(nil, _), do: ""
  def image_url(nil), do: ""

  def image_url(image, version) do
    ImageUploader.url({image.name, image}, version)
  end

  def image_url(image), do: image_url(image, :thumb)

  def favicon_url(nil), do: ""

  def favicon_url(favicon) do
    FaviconUploader.url({favicon.name, favicon}, :original)
  end

  def cover_url(nil), do: ""
  def cover_url(nil, _), do: ""

  def cover_url(album) do
    CoverartUploader.url({album.cover, album}, :large)
  end

  def cover_url(album, version) do
    CoverartUploader.url({album.cover, album}, version)
  end

  def avatar_url(user) do
    AvatarUploader.url({user.avatar, user}, :thumb)
  end

  def avatar_url(user, version) do
    AvatarUploader.url({user.avatar, user}, version)
  end

  def img(image, version, attrs \\ []) do
    img_tag(image_url(image, version), attrs)
  end

  def img(image) do
    img(image, :thumb)
  end

  def media_input(form, field, attrs) do
    content_tag :div, class: "input-group" do
      [
        content_tag :div, class: "input-group-prepend" do
          [
            content_tag :span, class: "input-group-text" do
              "Images"
            end,
            content_tag :button,
              type: "button",
              class: "btn btn-outline-primary",
              data_toggle: "modal",
              data_target: "#mediaLibrary" do
              "Select"
            end,
            content_tag :button, type: "button", class: "btn btn-outline-danger", id: "clear" do
              "Clear"
            end
          ]
        end,
        text_input(form, field, attrs)
      ]
    end
  end
end
