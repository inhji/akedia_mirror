defmodule AkediaWeb.SharedView do
  use AkediaWeb, :view
  alias Akedia.Content.{Like, Bookmark, Post}

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

  def mention_type(wm_property) do
    case wm_property do
      "like-of" -> "Likes"
      "in-reply-to" -> "Replies"
      "bookmark-of" -> "Bookmarks"
      "repost-of" -> "Reposts"
      action -> action
    end
  end

  def post_verb(%Bookmark{title: title, url: url}) do
    if title do
      {"bookmarked ", url, title}
    else
      {"bookmarked", nil, nil}
    end
  end

  def post_verb(%Like{entity: %{context: context}}) do
    if context do
      {"liked a post by ", context.author.url, context.author.name}
    else
      {"liked", nil, nil}
    end
  end

  def post_verb(%Post{reply_to: reply_to}) do
    if reply_to do
      {"replied to ", reply_to, reply_to}
    else
      {"posted", nil, nil}
    end
  end

  def render_post_verb({text, url, url_text}) do
    if url do
      raw(
        content_tag(:span, [
          content_tag(:span, text),
          link(url_text, to: url)
        ])
      )
    else
      raw(content_tag(:span, text))
    end
  end

  def microformats_class(%Bookmark{}), do: "u-bookmark-of"
  def microformats_class(%Like{}), do: "u-like-of"

  def class(expression, true_class, false_class \\ "") do
    if !!expression do
      true_class
    else
      false_class
    end
  end
end
