defmodule Akedia.Indie.Microformats.HCard do
  defstruct name: "", photo: ""

  def parse(%{:name => [name], :photo => [photo]} = properties) when is_map(properties) do
    %Akedia.Indie.Microformats.HCard{
      name: name,
      photo: photo
    }
  end
end
