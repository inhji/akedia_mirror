defmodule AkediaWeb.Helpers.Tags do
  def list_tags(tags) do
    tags
    |> Enum.map(&(&1.text))
    |> Enum.join(", ")
  end
end
