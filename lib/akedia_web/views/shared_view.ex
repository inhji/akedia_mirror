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

  def short_url(url) do
    uri = URI.parse(url)
    Path.join(uri.host, uri.path)
  end
end
