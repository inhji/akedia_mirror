defmodule AkediaWeb.Plugs.PlugWebmention.HandlerBehaviour do
  @moduledoc """
  Behaviour defining the interface for a PlugMicrosub Handler
  """

  @type handler_error ::
          {:error, handler_error_atom} | {:error, handler_error_atom, description :: String.t()}
  @type handler_error_atom :: :invalid_request | :forbidden | :insufficient_scope

  @callback handle_receive(body :: map) :: :ok | handler_error
end
