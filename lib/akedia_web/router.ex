defmodule AkediaWeb.Router do
  use AkediaWeb, :router

  import AkediaWeb.Plugs.PlugAssignUser

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
    plug :fetch_session
  end

  pipeline :auth do
    plug :check_user
  end

  # -----------------------------------------------------
  # Admin Routes
  # -----------------------------------------------------

  scope "/user", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/", UserController, only: [:edit, :update], singleton: true
    resources "/profiles", ProfileController
    get "/security", UserController, :security
  end

  scope "/", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/posts", PostController, except: [:show]
    get "/posts/drafts", PostController, :drafts

    resources "/bookmarks", BookmarkController, except: [:show]
    get "/bookmarks/drafts", BookmarkController, :drafts

    resources "/likes", LikeController, except: [:show]
    get "/likes/drafts", LikeController, :drafts

    resources "/topics", TopicController, except: [:index, :show]
    resources "/images", ImageController, except: [:show]

    get "/mentions", MentionController, :index

    scope "/queue" do
      get "/", QueueController, :index
    end
  end

  # -----------------------------------------------------
  # Public Routes
  # -----------------------------------------------------

  scope "/", AkediaWeb do
    pipe_through [:browser]

    get "/", PublicController, :index

    get "/tagged-with/:topic", PublicController, :tagged
    get "/search", PublicController, :search

    get "/about", UserController, :show
    get "/feed", AtomController, :index

    resources "/bookmarks", BookmarkController, only: [:show]
    resources "/images", ImageController, only: [:show]
    resources "/likes", LikeController, only: [:show]
    resources "/posts", PostController, only: [:show]
    resources "/topics", TopicController, only: [:index, :show]

    scope "/auth" do
      get "/register", UserController, :new
      post "/register", UserController, :create

      get "/login", SessionController, :new
      post "/login", SessionController, :create

      get "/two_factor", SessionController, :two_factor
      post "/webauthn", SessionController, :webauthn_create
      post "/totp", SessionController, :totp_create

      delete "/logout", SessionController, :delete
    end

    scope "/actor" do
      get "/", ActorController, :index
    end

    scope "/.well_known" do
      get "/webfinger", WellKnownController, :webfinger
    end
  end

  # -----------------------------------------------------
  # API Routes
  # -----------------------------------------------------

  scope "/api" do
    pipe_through [:api]

    scope "/webauthn" do
      post "/", AkediaWeb.WebauthnController, :create
      post "/callback", AkediaWeb.WebauthnController, :callback
      post "/session_callback", AkediaWeb.SessionController, :webauthn_callback
    end

    scope "/indie" do
      forward "/micropub",
              PlugMicropub,
              handler: Akedia.Indie.Micropub.Handler,
              json_encoder: Phoenix.json_library()

      forward "/webmention",
              AkediaWeb.Plugs.PlugWebmention,
              handler: Akedia.Indie.Webmentions.Handler,
              json_encoder: Phoenix.json_library()
    end
  end
end
