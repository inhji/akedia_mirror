defmodule AkediaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use AkediaWeb, :controller
      use AkediaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: AkediaWeb

      import Plug.Conn
      import Akedia.Auth, only: [logged_in?: 1]
      import AkediaWeb.Gettext
      import AkediaWeb.Plugs.PlugUser
      import AkediaWeb.Responses
      alias AkediaWeb.Router.Helpers, as: Routes
      require Logger
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/akedia_web/templates",
        pattern: "**/*",
        namespace: AkediaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
      import PhoenixActiveLink

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      use Timex

      import Akedia.Auth, only: [logged_in?: 1]

      import AkediaWeb.ErrorHelpers
      import AkediaWeb.Gettext
      import AkediaWeb.Helpers.Media

      import AkediaWeb.Helpers.Time,
        only: [date_iso: 1, date_pretty: 1, date_fuzzy: 1, time_tag: 1]

      import AkediaWeb.Helpers.Meta, only: [title: 2, title: 1]
      import AkediaWeb.Markdown, only: [to_html: 1]
      alias AkediaWeb.Router.Helpers, as: Routes
      alias AkediaWeb.{SharedView, LayoutView}
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import AkediaWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
