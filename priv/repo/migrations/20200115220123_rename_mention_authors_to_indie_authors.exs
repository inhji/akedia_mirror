defmodule Akedia.Repo.Migrations.RenameMentionAuthorsToIndieAuthors do
  use Ecto.Migration

  def change do
    rename table("mention_authors"), to: table("indie_authors")
  end
end
