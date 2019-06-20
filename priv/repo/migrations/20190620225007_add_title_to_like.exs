defmodule Akedia.Repo.Migrations.AddTitleToLike do
  use Ecto.Migration

  def change do
    alter table(:likes) do
      add :title, :string
    end
  end
end
