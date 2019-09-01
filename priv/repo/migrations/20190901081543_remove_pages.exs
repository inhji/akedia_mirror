defmodule Akedia.Repo.Migrations.RemovePages do
  use Ecto.Migration

  def up do
  	drop table(:pages)
  end

  def down do
  end
end
