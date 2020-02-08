defmodule AkediaWeb.Helpers.Media do
  use Phoenix.HTML

  alias Akedia.Media.{
    AuthorUploader,
    AvatarUploader,
    ContextUploader,
    CoverUploader,
    FaviconUploader,
    ImageUploader
  }

  def image_url(nil), do: ""
  def image_url(image), do: image_url(image, :thumb)
  def image_url(nil, _), do: ""
  def image_url(image, version), do: ImageUploader.url({image.name, image}, version)

  def favicon_url(nil), do: ""
  def favicon_url(favicon), do: FaviconUploader.url({favicon.name, favicon}, :original)

  def cover_url(user), do: CoverUploader.url({user.cover, user}, :wide)
  def cover_url(user, version), do: CoverUploader.url({user.cover, user}, version)

  def avatar_url(user), do: AvatarUploader.url({user.avatar, user}, :thumb)
  def avatar_url(user, version), do: AvatarUploader.url({user.avatar, user}, version)

  def author_url(author), do: AuthorUploader.url({author.photo, author}, :thumb)
  def author_url(author, version), do: AuthorUploader.url({author.photo, author}, version)

  def context_url(context, _) when is_nil(context),
    do: nil

  def context_url(context) when is_nil(context),
    do: nil

  def context_url(%{photo: photo} = context),
    do: ContextUploader.url({photo, context}, :wide)

  def context_url(%{photo: photo} = context, version),
    do: ContextUploader.url({photo, context}, version)

  def img(image), do: img(image, :thumb)
  def img(image, version, attrs \\ []), do: img_tag(image_url(image, version), attrs)
end
