defmodule Akedia.Repo.Migrations.DropChannels do
  use Ecto.Migration

  def up do
    drop_if_exists table(:feed_entries)
    drop_if_exists table(:feeds)
    drop_if_exists table(:channels)

    drop_if_exists index(:feeds, [:channel_id])
    drop_if_exists index(:feed_entries, [:feed_id])
    drop_if_exists unique_index(:feed_entries, [:url])
  end

  def down do
  end
end
