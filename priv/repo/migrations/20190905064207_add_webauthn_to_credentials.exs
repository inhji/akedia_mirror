defmodule Akedia.Repo.Migrations.AddWebauthnToCredentials do
  use Ecto.Migration

  def change do
  	alter table(:credentials) do
  		add :device_name, :string
  		add :external_id, :string
  		add :public_key, :string
  	end
  end
end
