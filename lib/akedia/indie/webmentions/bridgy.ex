defmodule Akedia.Indie.Webmentions.Bridgy do
  @bridgy_endpoint "https://brid.gy/publish/webmention"
  @bridgy_github_target "https://brid.gy/publish/github"

  require Logger

  def maybe_publish_to_github(_, nil), do: nil
  def maybe_publish_to_github(%{:entity_id => entity_id} = schema, url) do
    if String.starts_with?(url, "https://github.com/") do
      Akedia.Indie.create_or_update_syndication(%{
        type: "github",
        entity_id: entity_id
      })

      do_publish_to_github(schema)
    end
  end

  def do_publish_to_github(%{:entity_id => entity_id} = schema) do
    www_source = Akedia.url(schema)
    www_target = URI.encode_www_form(@bridgy_github_target)
    body = "source=#{www_source}&target=#{www_target}"

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      Akedia.HTTP.user_agent()
    ]

    case HTTPoison.post(@bridgy_endpoint, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        json = Jason.decode!(body)

        Akedia.Indie.create_or_update_syndication(%{
          type: "github",
          entity_id: entity_id,
          url: json["url"]
        })

      {:ok, %HTTPoison.Response{body: body}} ->
        Logger.error(body)
    end
  end
end
