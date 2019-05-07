defmodule Akedia.Helpers do
  def random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  def unique_slug(string, length \\ 5) do
    Slugger.slugify("#{string}-#{random_string(length)}")
  end
end
