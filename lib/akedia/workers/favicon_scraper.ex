defmodule Akedia.Workers.FaviconScraper do
  require Logger
  use Que.Worker
  alias Akedia.Repo
  alias Akedia.Content.{Bookmark}
  alias Akedia.Media.{Favicon, FaviconUploader}
  alias Scrape.Website

  def perform(%Bookmark{url: url} = bookmark) do
    with %Website{favicon: favicon} <- Scrape.website(url),
         favicon_record <- insert_favicon(url, favicon) do
      new_url = FaviconUploader.url(favicon_record)
      IO.inspect(new_url)
    else
      err -> Logger.error(err)
    end
  end

  # TODO: THIS DOES NOT SEEM RIGHT..
  # INSERT INTO "favicons" ("tld","inserted_at","updated_at") VALUES ($1,$2,$3) RETURNING "id" ["www.golem.de", ~N[2019-05-04 15:26:10], ~N[2019-05-04 15:26:10]]
  # :original
  # %Arc.File{
  #   binary: nil,
  #   file_name: "apple-touch-icon-114x114.png",
  #   path: "/tmp/Y65O5OYAZ3FD64DGVGPRX44MR4YOIHA6.png"
  # }
  # %Akedia.Media.Favicon{
  #   __meta__: #Ecto.Schema.Metadata<:loaded, "favicons">,
  #   id: 10,
  #   inserted_at: ~N[2019-05-04 15:26:10],
  #   name: nil,
  #   tld: "www.golem.de",
  #   updated_at: ~N[2019-05-04 15:26:10]
  # }
  # [debug] QUERY OK db=7.7ms queue=0.2ms
  # UPDATE "favicons" SET "name" = $1, "updated_at" = $2 WHERE "id" = $3 ["apple-touch-icon-114x114.png?63724202770", ~N[2019-05-04 15:26:10], 10]
  # :original
  # %Akedia.Media.Favicon{
  #   __meta__: #Ecto.Schema.Metadata<:loaded, "favicons">,
  #   id: 10,
  #   inserted_at: ~N[2019-05-04 15:26:10],
  #   name: %{
  #     file_name: "apple-touch-icon-114x114.png",
  #     updated_at: ~N[2019-05-04 15:26:10.937434]
  #   },
  #   tld: "www.golem.de",
  #   updated_at: ~N[2019-05-04 15:26:10]
  # }
  # nil


  def insert_favicon(url, favicon_url) do
    tld = URI.parse(url).host

    IO.inspect(url)
    IO.inspect(favicon_url)

    %Favicon{}
    |> Favicon.changeset(%{tld: tld})
    |> IO.inspect()
    |> Repo.insert!()
    |> Favicon.changeset(%{name: favicon_url})
    |> Repo.update!()
  end
end
