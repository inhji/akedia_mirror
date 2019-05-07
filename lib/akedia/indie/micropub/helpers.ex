defmodule Akedia.Indie.Micropub.Helpers do
  @spec abs_url(binary(), binary()) :: binary()
  def abs_url(base, relative_path) do
    base
    |> URI.parse()
    |> URI.merge(relative_path)
    |> to_string()
  end
end
