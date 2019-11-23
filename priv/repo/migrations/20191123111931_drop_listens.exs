defmodule Akedia.Repo.Migrations.DropListens do
  use Ecto.Migration

  def up do
  	drop_if_exists table(:listens)
  	drop_if_exists index(:listens, [:artist])
  	drop_if_exists index(:listens, [:track])

  	drop_if_exists table(:albums)
  	drop_if_exists table(:artists)
  end

  def down do
  	
  end
end
