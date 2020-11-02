defmodule Akedia.Media.AuthorUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name) |> String.downcase())
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x100^ -format png", :png}
  end

  # Override the persisted filenames:
  def filename(version, {_file, scope}) do
    "#{version}-#{scope.id}"
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, _scope}) do
    "authors"
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
