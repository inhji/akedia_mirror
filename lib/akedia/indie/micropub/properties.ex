defmodule Akedia.Indie.Micropub.Properties do
  @array_attributes ["category"]
  @html_attributes ["content"]

  @allowed_properties %{
    "category" => :tags,
    "like-of" => :like_of,
    "bookmark-of" => :bookmark_of,
    "in-reply-to" => :in_reply_to,
    "content" => :content,
    "name" => :title,
    "url" => :url
  }

  def parse(properties) do
    properties
    |> Enum.reduce(%{}, &add_replace_properties/2)
  end

  def parse(replace, add, delete) do
    add_replace =
      replace
      |> Map.merge(add)
      |> Enum.reduce(%{}, &add_replace_properties/2)

    delete
    |> Enum.reduce(add_replace, &remove_properties/2)
  end

  def add_replace_properties({k, [head | tail]}, props) do
    if Enum.member?(@allowed_properties, k) do
      key = @allowed_properties[k]

      cond do
        Enum.member?(@array_attributes, k) ->
          Map.put(props, key, [head | tail])

        Enum.member?(@html_attributes, k) and is_map(head) ->
          value = get_html_content(head)
          Map.put(props, key, value)

        true ->
          Map.put(props, key, head)
      end
    else
      props
    end
  end

  def get_html_content(content_map) do
    cond do
      Map.has_key?(content_map, "html") -> content_map["html"]
      Map.has_key?(content_map, "value") -> content_map["value"]
      true -> ""
    end
  end

  def remove_properties({k, _v}, props) do
    case key = @allowed_properties[k] do
      nil -> props
      _ -> Map.put(props, key, nil)
    end
  end

  def get_type_by_props(%{"bookmark-of" => _}), do: :bookmark
  def get_type_by_props(%{"like-of" => _}), do: :like
  def get_type_by_props(%{"in-reply-to" => _}), do: :post
  def get_type_by_props(%{"content" => _}), do: :post
  def get_type_by_props(_), do: :unknown

  def get_tags(%{"category" => [""]}), do: []
  def get_tags(%{"category" => tags}), do: tags
  def get_tags(_), do: []

  def get_title(%{"name" => [title]}), do: title
  def get_title(_), do: nil

  def get_content(%{"content" => [content]}), do: content
  def get_content(%{"content" => [%{"html" => [content_html]}]}), do: content_html
  def get_content(_), do: nil

  def get_bookmarked_url(%{"bookmark-of" => [url]}), do: url
  def get_bookmarked_url(_), do: nil

  def get_liked_url(%{"like-of" => [url]}), do: url
  def get_liked_url(_), do: nil

  def get_reply_to(%{"in-reply-to" => [reply_to]}), do: reply_to
  def get_reply_to(_), do: nil

  def is_published?(%{"post-status" => ["draft"]}), do: false
  def is_published?(_), do: true

  def get_photo(%{"photo" => [photo]}), do: photo
  def get_photo(_), do: nil
end
