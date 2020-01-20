defmodule Akedia.Repo.Migrations.AddIndexOnAuthorUrl do
  use Ecto.Migration

  def change do
    create unique_index("indie_authors", [:url])
  end
end
