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
end
