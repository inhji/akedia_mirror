defmodule AkediaWeb.SearchView do
  use AkediaWeb, :view

  def render("meta.search.html", assigns) do
    [title("Search", assigns)]
  end

  def inner_type(%Akedia.Content.Entity{} = entity) do
    cond do
      entity.bookmark != nil -> entity.bookmark
      entity.page != nil -> entity.page
      entity.story != nil -> entity.story
      entity.like != nil -> entity.like
      entity.post != nil -> entity.post
    end
  end

  def inner_name(%{ :entity_id => _entity_id } = schema) do
    %name{} = schema

    name
    |> to_string()
    |> String.split(".")
    |> List.last()
  end
end
