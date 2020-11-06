defmodule Akedia.Accounts.AvatarUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 200x200^ -gravity center -format png", :png}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    "me_#{version}"
  end

  # Override the storage directory:
  def storage_dir(_, _) do
    "user"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    "/images/me.jpg"
  end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
