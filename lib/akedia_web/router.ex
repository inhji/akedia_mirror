defmodule AkediaWeb.Router do
  use AkediaWeb, :router
  import AkediaWeb.Plugs.User, only: [
    assign_user: 2,
    check_user: 2,
    refresh_user: 2,
    check_loggedin: 2
  ]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_loggedin
    plug :assign_user
    plug :refresh_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :check_user
  end

  scope "/", AkediaWeb do
    pipe_through [:browser]

    get "/", PublicController, :index

    resources "/stories", StoryController, only: [:show, :index]
    resources "/bookmarks", BookmarkController, only: [:show, :index]
    resources "/pages", PageController, only: [:show, :index]
    resources "/topics", TopicController, only: [:show, :index]
    resources "/images", ImageController, only: [:show, :index]
    resources "/likes", LikeController, only: [:show, :index]

    get "/search", SearchController, :search

    get "/tagged-with/:topic", TopicController, :tagged

    scope "/listens" do
      get "/by_artist", ListenController, :by_artist
    end

    scope "/auth" do
      get "/register", UserController, :new
      post "/register", UserController, :create

      get "/login", SessionController, :new
      post "/login", SessionController, :create
      delete "/logout", SessionController, :delete
    end
  end

  scope "/indie" do
    pipe_through [:api]

    forward "/micropub",
            PlugMicropub,
            handler: Akedia.Indie.Micropub.Handler,
            json_encoder: Phoenix.json_library()
  end

  scope "/user", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/", UserController, only: [:show, :edit, :update], singleton: true
    resources "/profiles", ProfileController
  end

  scope "/admin", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/stories", StoryController, except: [:show, :index]
    resources "/bookmarks", BookmarkController, except: [:show, :index]
    resources "/pages", PageController, except: [:show, :index]
    resources "/topics", TopicController, except: [:show, :index]
    resources "/images", ImageController, except: [:show, :index]
    resources "/likes", LikeController, except: [:show, :index]
  end
end
