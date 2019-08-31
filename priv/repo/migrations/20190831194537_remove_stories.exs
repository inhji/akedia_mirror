defmodule Akedia.Repo.Migrations.RemoveStories do
  use Ecto.Migration

  def up do
  	drop table(:stories)
  end

  def down do
  end
end
