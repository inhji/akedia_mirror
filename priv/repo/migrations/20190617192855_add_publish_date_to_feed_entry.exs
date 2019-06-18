defmodule Akedia.Repo.Migrations.AddPublishDateToFeedEntry do
  use Ecto.Migration

  def change do
    alter table(:feed_entries) do
      add :published_at, :utc_datetime
    end
  end
end
