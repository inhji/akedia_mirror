defmodule Akedia.Repo.Migrations.AddSlugToArtist do
  use Ecto.Migration

  def change do
  	alter table(:artists) do
  		add :slug, :string
  	end
  end
end
