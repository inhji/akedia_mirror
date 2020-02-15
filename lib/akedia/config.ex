defmodule Akedia.Config do
  def get(key, default \\ nil) when is_atom(key) do
    :akedia
    |> Application.get_env(__MODULE__)
    |> Keyword.get(key, default)
  end
end
