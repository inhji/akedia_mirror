defmodule Akedia.Repo.Migrations.AddImageToArtists do
  use Ecto.Migration

  def change do
		alter table(:artists) do
  		add :image, :string
  	end
  end
end
