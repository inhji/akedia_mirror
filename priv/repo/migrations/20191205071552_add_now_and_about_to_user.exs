defmodule Akedia.Repo.Migrations.AddNowAndAboutToUser do
  use Ecto.Migration

  def change do
  	alter table(:users) do
  		add :about, :text
  	end

  	rename table(:users), :bio, to: :now
  end
end
