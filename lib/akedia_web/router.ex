defmodule AkediaWeb.Router do
  use AkediaWeb, :router

  import AkediaWeb.Plugs.PlugUser
  import AkediaWeb.Plugs.PlugFormat

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

  pipeline :activitypub do
    plug :accepts, ~w(html json jsonap jsonld)
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :check_loggedin
    plug :assign_user
    plug :refresh_user
    plug :put_req_format
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug :check_user
  end

  # -----------------------------------------------------
  # Public Routes
  # -----------------------------------------------------

  scope "/", AkediaWeb do
    pipe_through [:browser]

    get "/", PublicController, :index

    get "/tagged-with/:topic", PublicController, :tagged
    get "/search", PublicController, :search
    get "/feed", AtomController, :index

    resources "/posts", PostController
    resources "/bookmarks", BookmarkController
    resources "/images", ImageController
    resources "/likes", LikeController
    resources "/topics", TopicController

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

    scope "/.well-known" do
      get "/webfinger", WellKnownController, :webfinger
      get "/host-meta", WellKnownController, :host_meta
    end
  end

  scope "/", AkediaWeb do
    pipe_through :activitypub

    get "/user", UserController, :show
    get "/inbox", InboxController, :index
    get "/outbox", OutboxController, :index
  end

  # -----------------------------------------------------
  # Protected Routes
  # -----------------------------------------------------

  scope "/user", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/", UserController, only: [:edit, :update], singleton: true
    resources "/profiles", ProfileController
    get "/security", UserController, :security
  end

  scope "/admin", AkediaWeb do
    pipe_through [:browser, :auth]

    get "/mentions", MentionController, :index

    scope "/queue" do
      get "/", QueueController, :index
      get "/drafts", QueueController, :drafts
      get "/jobs", QueueController, :jobs
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
              handler: Akedia.Webmentions.Handler,
              json_encoder: Phoenix.json_library()
    end
  end
end
