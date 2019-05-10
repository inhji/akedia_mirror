defmodule Akedia.Slug do
  import Ecto.Changeset, only: [get_field: 2, put_change: 3]

  @slug_unique_id_length 5

  def maybe_generate_slug(changeset, options \\ [add_random: true]) do
    add_random = options[:add_random]

    with true <- changeset.valid?,
         nil <- get_field(changeset, :slug) do
      prepared_string = get_slug(changeset)
      do_create_slug(changeset, prepared_string, add_random)
    else
      _ -> changeset
    end
  end

  def do_create_slug(changeset, string, add_random) do
    slug =
      if add_random do
        Slugger.slugify("#{string}-#{random_string(@slug_unique_id_length)}")
      else
        Slugger.slugify(string)
      end

    changeset
    |> put_change(:slug, slug)
  end

  def get_slug(changeset) do
    [:title, :content, :url, :text]
    |> Enum.map(&get_slug_from(changeset, &1))
    |> Enum.filter(&is_binary/1)
    |> List.first()
    |> String.downcase()
  end

  def get_slug_from(changeset, :title) do
    case get_field(changeset, :title) do
      nil -> nil
      title -> title
    end
  end

  def get_slug_from(changeset, :text) do
    case get_field(changeset, :text) do
      nil -> nil
      text -> text
    end
  end

  def get_slug_from(changeset, :content) do
    case get_field(changeset, :content) do
      nil ->
        nil

      content ->
        content
        |> String.slice(0..15)
    end
  end

  def get_slug_from(changeset, :url) do
    case get_field(changeset, :url) do
      nil ->
        nil

      url ->
        url
        |> URI.parse()
        |> Map.get(:host)
    end
  end

  def random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
