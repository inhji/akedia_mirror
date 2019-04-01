defmodule Akedia.Content.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
