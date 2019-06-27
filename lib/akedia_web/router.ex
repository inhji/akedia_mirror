defmodule AkediaWeb.Router do
  use AkediaWeb, :router
  # alias AkediaWeb.Plugs.PlugIndieAuth
  import AkediaWeb.Plugs.User,
    only: [
      assign_user: 2,
      check_user: 2,
      refresh_user: 2,
      check_loggedin: 2
    ]

  import AkediaWeb.Plugs.Settings, only: [assign_settings: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_loggedin
    plug :assign_user
    plug :refresh_user
    plug :assign_settings
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
    get "/tagged-with/:topic", PublicController, :tagged
    get "/search", SearchController, :search

    resources "/stories", StoryController, only: [:show, :index]
    resources "/bookmarks", BookmarkController, only: [:show, :index]
    resources "/pages", PageController, only: [:show, :index]
    resources "/images", ImageController, only: [:show, :index]
    resources "/likes", LikeController, only: [:show, :index]
    resources "/posts", PostController, only: [:show, :index]

    get "/listens", ListenController, :index
    resources "/artists", ArtistController, only: [:show, :index]
    resources "/albums", AlbumController, only: [:show]

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

    forward "/microsub",
            Akedia.Plugs.PlugMicrosub,
            handler: Akedia.Indie.Microsub.Handler,
            json_encoder: Phoenix.json_library()

    # forward "/auth",
    #         PlugIndieAuth,
    #         handler: Akedia.Indie.IndieAuth.Handler,
    #         json_encoder: Phoenix.json_library()
  end

  scope "/user", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/", UserController, only: [:show, :edit, :update], singleton: true
    resources "/profiles", ProfileController
  end

  scope "/admin", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/posts", PostController, except: [:show, :index]
    get "/posts/drafts", PostController, :drafts

    resources "/stories", StoryController, except: [:show, :index]
    get "/stories/drafts", StoryController, :drafts

    resources "/bookmarks", BookmarkController, except: [:show, :index]
    get "/bookmarks/drafts", BookmarkController, :drafts

    resources "/pages", PageController, except: [:show, :index]
    get "/pages/drafts", PageController, :drafts

    resources "/likes", LikeController, except: [:show, :index]
    get "/likes/drafts", LikeController, :drafts

    resources "/topics", TopicController, except: [:show, :index]
    resources "/images", ImageController, except: [:show, :index]

    resources "/artists", ArtistController, except: [:show, :index]
    resources "/albums", AlbumController, except: [:show]

    resources "/channels", ChannelController do
      resources "/feeds", FeedController
    end
  end
end
