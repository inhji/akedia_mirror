defmodule AkediaWeb.Helpers.Media do
  use Phoenix.HTML

  def image_url(nil, _), do: ""
  def image_url(image, version) do
    Akedia.Media.ImageUploader.url({image.name, image}, version)
  end

  def image_url(nil), do: ""
  def image_url(image), do: image_url(image, :thumb)

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
            content_tag :button, type: "button", class: "btn btn-outline-primary", data_toggle: "modal", data_target: "#mediaLibrary" do
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
