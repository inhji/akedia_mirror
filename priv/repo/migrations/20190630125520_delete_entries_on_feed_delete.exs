defmodule Akedia.Repo.Migrations.DeleteEntriesOnFeedDelete do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE feed_entries DROP CONSTRAINT feed_entries_feed_id_fkey")

    alter table(:feed_entries) do
      modify :feed_id, references(:feeds, on_delete: :delete_all)
    end
  end

  def down do
    execute("ALTER TABLE feed_entries DROP CONSTRAINT feed_entries_feed_id_fkey")

    alter table(:feed_entries) do
      modify :feed_id, references(:feeds, on_delete: :nothing)
    end
  end
end
