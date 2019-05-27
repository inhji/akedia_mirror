defmodule Akedia.Indie.Microformats.HCard do
  defstruct name: "", photo: ""

  def parse(%{:name => [name], :photo => [photo]} = properties) when is_map(properties) do
    {:ok,
     %Akedia.Indie.Microformats.HCard{
       name: name,
       photo: photo
     }}
  end

  def parse(_), do: {:error, :no_hcard_found}
end
