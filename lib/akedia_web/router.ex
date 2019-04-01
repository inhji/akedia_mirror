defmodule AkediaWeb.Router do
  use AkediaWeb, :router
  import Akedia.Auth.Plug, only: [current_user: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Akedia.Auth.BrowserPipeline
    plug :current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Akedia.Auth.AuthPipeline
    plug :current_user
  end

  scope "/", AkediaWeb do
    pipe_through [:browser]

    get "/", PublicController, :index

    resources "/stories", StoryController, only: [:show, :index]
    resources "/bookmarks", BookmarkController, only: [:show, :index]
    resources "/pages", PageController, only: [:show, :index]
    resources "/topics", TopicController, only: [:show, :index]
    resources "/images", ImageController, only: [:show, :index]

    get "/tagged-with/:topic", TopicController, :tagged

    scope "/auth" do
      get "/register", UserController, :new
      post "/register", UserController, :create

      get "/login", SessionController, :new
      post "/login", SessionController, :create
      delete "/logout", SessionController, :delete
    end
  end

  scope "/user", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/", UserController, only: [:show, :edit, :update], singleton: true
  end

  scope "/admin", AkediaWeb do
    pipe_through [:browser, :auth]

    resources "/stories", StoryController, except: [:show, :index]
    resources "/bookmarks", BookmarkController, except: [:show, :index]
    resources "/pages", PageController, except: [:show, :index]
    resources "/topics", TopicController, except: [:show, :index]
    resources "/images", ImageController, except: [:show, :index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", AkediaWeb do
  #   pipe_through :api
  # end
end
