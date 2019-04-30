defmodule Akedia.Repo.Migrations.AddFaviconUrlToBookmark do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :favicon, :string
    end
  end
end
