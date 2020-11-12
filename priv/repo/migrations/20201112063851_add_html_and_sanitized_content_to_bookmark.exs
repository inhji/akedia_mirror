defmodule Akedia.Repo.Migrations.AddHtmlAndSanitizedContentToBookmark do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :content_html, :text
      add :content_sanitized, :text
    end
  end
end
