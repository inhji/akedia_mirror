defmodule Akedia.Repo.Migrations.AddHtmlAndSanitizedContentToPost do
  use Ecto.Migration

  def change do
  	alter table(:posts) do
    	add :content_html, :text
    	add :content_sanitized, :text
    end
  end
end
