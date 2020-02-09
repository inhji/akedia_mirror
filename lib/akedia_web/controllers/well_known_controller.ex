defmodule AkediaWeb.WellKnownController do
  use AkediaWeb, :controller

  require Logger

  plug :accepts, ["json", "jrd", "xrd"]

  def webfinger(conn, %{"resource" => resource}) do
    {:ok, regex} = Regex.compile("(acct:)?\\w+@#{Akedia.url()}")

    with true <- Regex.match?(regex, resource),
         username <- extract_username(resource),
         true <- Akedia.Accounts.user_exists?(username) do
      conn
      |> put_resp_content_type(MIME.type("jrd"))
      |> json(%{
        "subject" => resource,
        "links" => [
          %{
            "rel" => "self",
            "type" => "application/activity+json",
            "href" => Akedia.Accounts.User.actor_url()
          }
        ]
      })
    else
      error ->
        IO.inspect(error)
        bad_request(conn)
    end
  end

  def webfinger(conn, _params) do
    bad_request(conn)
  end

  def host_meta(conn, _params) do
    base_url = Akedia.url()

    xml =
      {
        :XRD,
        %{xmlns: "http://docs.oasis-open.org/ns/xri/xrd-1.0"},
        {
          :Link,
          %{
            rel: "lrdd",
            type: "application/xrd+xml",
            template: "#{base_url}/.well-known/webfinger?resource={uri}"
          }
        }
      }
      |> Akedia.XmlBuilder.to_doc()

    conn
    |> put_resp_content_type(MIME.type("xrd"))
    |> send_resp(200, xml)
  end

  defp extract_username(resource) do
    resource
    |> String.replace("acct:", "")
    |> String.replace("@#{Akedia.url()}", "")
  end
end
