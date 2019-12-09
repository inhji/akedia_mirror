defmodule Akedia.Indie do
  def config(key, default) do
    config = Application.get_env(:akedia, Akedia.Indie)
    Keyword.get(config, key, default)
  end
end
