defmodule AkediaWeb.Router do
  use AkediaWeb, :router

  import AkediaWeb.Plugs.PlugAssignUser
  import AkediaWeb.Plugs.PlugAssignSettings
  import AkediaWeb.Plugs.PlugAdminLayout

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

  pipeline :admin do
    plug :admin_layout
  end

  scope "/", AkediaWeb do
    pipe_through [:browser]

    get "/", PublicController, :index
    get "/tagged-with/:topic", PublicController, :tagged
    get "/now", PublicController, :now
    get "/stream", PublicController, :stream
    get "/about", PublicController, :about

    get "/topics", TopicController, :index
    get "/search", SearchController, :search
    get "/feed", AtomController, :index

    resources "/bookmarks", BookmarkController, only: [:show]
    resources "/images", ImageController, only: [:show]
    resources "/likes", LikeController, only: [:show]
    resources "/posts", PostController, only: [:show]

    scope "/listens" do
      get "/", ListenController, :index

      resources "/artists", ArtistController, only: [:show]
      resources "/albums", AlbumController, only: [:show]
    end

    scope "/auth" do
      get "/register", UserController, :new
      post "/register", UserController, :create

      get "/login", SessionController, :new
      post "/login", SessionController, :create
      delete "/logout", SessionController, :delete
    end
  end

  scope "/admin", AkediaWeb do
    pipe_through [:browser, :auth, :admin]

    get "/", AdminController, :index

    resources "/user", UserController, only: [:show, :edit, :update], singleton: true
    resources "/user/profiles", ProfileController

    resources "/posts", PostController, except: [:show]
    get "/posts/drafts", PostController, :drafts

    resources "/bookmarks", BookmarkController, except: [:show]
    get "/bookmarks/drafts", BookmarkController, :drafts

    resources "/likes", LikeController, except: [:show]
    get "/likes/drafts", LikeController, :drafts

    resources "/topics", TopicController, except: [:show]
    resources "/images", ImageController, except: [:show]

    resources "/artists", ArtistController, except: [:show]
    resources "/albums", AlbumController, except: [:show]

    resources "/channels", ChannelController do
      resources "/feeds", FeedController
    end

    get "/mentions", MentionController, :index
  end

  scope "/indie" do
    pipe_through [:api]

    forward "/micropub",
            PlugMicropub,
            handler: Akedia.Indie.Micropub.Handler,
            json_encoder: Phoenix.json_library()

    forward "/microsub",
            AkediaWeb.Plugs.PlugMicrosub,
            handler: Akedia.Indie.Microsub.Handler,
            json_encoder: Phoenix.json_library()

    forward "/webmention",
            AkediaWeb.Plugs.PlugWebmention,
            handler: Akedia.Indie.Webmentions.Handler,
            json_encoder: Phoenix.json_library()
  end
end
