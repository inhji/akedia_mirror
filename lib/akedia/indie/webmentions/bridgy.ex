defmodule Akedia.Indie.Webmentions.Bridgy do
  require Logger

  def maybe_publish_to_github(_, nil), do: nil

  def maybe_publish_to_github(%{:entity_id => entity_id} = schema, url) do
    if String.starts_with?(url, "https://github.com/") do
      Akedia.Content.create_or_update_syndication(%{
        type: "github",
        entity_id: entity_id
      })

      do_publish_to_github(schema)
    end
  end

  def do_publish_to_github(%{:entity_id => entity_id} = schema) do
    endpoint = Akedia.Indie.config(:bridgy_endpoint, "")
    target = Akedia.Indie.config(:bridgy_github_target, "")
    www_source = Akedia.url(schema)
    www_target = URI.encode_www_form(target)
    body = "source=#{www_source}&target=#{www_target}"

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      Akedia.HTTP.user_agent()
    ]

    case HTTPoison.post(endpoint, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 201, body: body}} ->
        json = Jason.decode!(body)

        Akedia.Content.create_or_update_syndication(%{
          type: "github",
          entity_id: entity_id,
          url: json["url"]
        })

      {:ok, %HTTPoison.Response{body: body}} ->
        Logger.error(body)
    end
  end
end
