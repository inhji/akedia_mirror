defmodule Akedia.Repo.Migrations.SimplifyImages do
  use Ecto.Migration

  def up do
  	drop_if_exists table("entity_images")
  end

  def down do
  end
end
