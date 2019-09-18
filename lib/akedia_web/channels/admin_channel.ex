defmodule AkediaWeb.AdminChannel do
  use Phoenix.Channel

  def join("admin:dashboard", _message, socket) do
    {:ok, socket}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("get_listens", _params, socket) do
    listens = Akedia.Listens.listens_per_month()

    push(socket, "listens", %{listens: listens})
    {:noreply, socket}
  end

  def handle_in("get_posts", _params, socket) do
    posts = Akedia.Content.schema_per_week(Akedia.Content.Post)
    bookmarks = Akedia.Content.schema_per_week(Akedia.Content.Bookmark)
    likes = Akedia.Content.schema_per_week(Akedia.Content.Like)

    push(socket, "posts", %{posts: posts, bookmarks: bookmarks, likes: likes})
    {:noreply, socket}
  end

  def handle_in("get_bookmarks", _params, socket) do
    bookmarks = Akedia.Content.schema_per_week(Akedia.Content.Bookmark)

    push(socket, "bookmarks", %{bookmarks: bookmarks})
    {:noreply, socket}
  end

  def handle_in("get_likes", _params, socket) do
    likes = Akedia.Content.schema_per_week(Akedia.Content.Like)

    push(socket, "likes", %{likes: likes})
    {:noreply, socket}
  end

  def handle_in("get_weather", _params, socket) do
    weather = Akedia.Workers.Weather.get_weather()

    push(socket, "weather", %{weather: weather})
    {:noreply, socket}
  end
end
