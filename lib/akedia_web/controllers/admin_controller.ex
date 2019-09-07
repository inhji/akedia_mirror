defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    weather = Akedia.Workers.Weather.get_weather()
    listens = Akedia.Listens.listens_per_month()
    posts = Akedia.Content.schema_per_week(Akedia.Content.Post)
    bookmarks = Akedia.Content.schema_per_week(Akedia.Content.Bookmark)
    likes = Akedia.Content.schema_per_week(Akedia.Content.Like)

    render(conn, "index.html",
      weather: weather,
      listens: listens,
      posts: posts,
      bookmarks: bookmarks,
      likes: likes
    )
  end

  def webauthn(conn, _params) do
    user = Akedia.Accounts.get_user!()
    credential = Akedia.Accounts.get_credential_by_user(user.id)

    render(conn, "webauthn.html", credential: credential)
  end
end
