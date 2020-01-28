defmodule AkediaWeb.SharedView do
  use AkediaWeb, :view

  def github_syndication(%{:entity => %{:syndications => syndications}}) do
    case Enum.empty?(syndications) do
      true ->
        nil

      false ->
        Enum.find(syndications, nil, fn %{:type => type} -> type == "github" end)
    end
  end

  def has_topics?(schema) do
    !Enum.empty?(schema.entity.topics)
  end

  def has_reply?(schema) do
    Map.has_key?(schema, :reply_to) and not is_nil(schema.reply_to)
  end

  def has_url?(schema) do
    Map.has_key?(schema, :url)
  end

  def short_url(url) do
    uri = URI.parse(url)
    Path.join(uri.host, uri.path)
  end

  def microformats_class(%Akedia.Content.Bookmark{}), do: "u-bookmark-of"
  def microformats_class(%Akedia.Content.Like{}), do: "u-like-of"
end
