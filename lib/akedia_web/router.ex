defmodule AkediaWeb.Router do
  use AkediaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AkediaWeb do
    pipe_through :browser

    get "/", PublicController, :index

    resources "/stories", StoryController
    resources "/bookmarks", BookmarkController
    resources "/pages", PageController
    resources "/topics", TopicController
    get "/tagged/:topic", TopicController, :tagged

    scope "/auth" do
      get "/register", UserController, :new
      post "/register", UserController, :create
    end

    resources "/user", UserController, only: [:show, :edit, :update], singleton: true
  end

  # Other scopes may use custom stacks.
  # scope "/api", AkediaWeb do
  #   pipe_through :api
  # end
end
