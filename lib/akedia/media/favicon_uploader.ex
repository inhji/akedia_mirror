defmodule Akedia.Media.FaviconUploader do
  use Arc.Definition
  use Arc.Ecto.Definition

  # Include ecto support (requires package arc_ecto installed):
  # use Arc.Ecto.Definition

  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png .ico .svg) |> Enum.member?(Path.extname(file.file_name))
  end

  # Override the persisted filenames:
  def filename(_version, {_file, scope}) do
    scope.hostname
  end

  # Override the storage directory:
  def storage_dir(_, _) do
    "uploads/favicons"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
