defmodule Akedia.Media.CoverUploader do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :wide]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:wide, _) do
    {:convert, "-strip -gravity center -crop 100%x60% -format png", :png}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    "cover_#{version}"
  end

  # Override the storage directory:
  def storage_dir(_, _) do
    "uploads/user"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    "/images/cover.jpg"
  end
end
