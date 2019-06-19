defmodule Akedia.Repo.Migrations.AddIsReadToFeedEntry do
  use Ecto.Migration

  def change do
    alter table(:feed_entries) do
      add :is_read, :boolean, default: false
    end
  end
end
