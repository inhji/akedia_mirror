defmodule Akedia.Repo.Migrations.AddUsernameToAuthors do
  use Ecto.Migration

  def change do
    alter table(:indie_authors) do
      add :username, :string
    end
  end
end
