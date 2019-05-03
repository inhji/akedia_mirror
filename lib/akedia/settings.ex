defmodule Akedia.Settings do
  def get(key) when is_atom(key) do
    Application.get_env(:akedia, Akedia.Settings)[key]
  end

  def get_all() do
    Application.get_env(:akedia, Akedia.Settings)
  end
end
