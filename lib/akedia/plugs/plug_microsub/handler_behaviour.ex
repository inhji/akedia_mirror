defmodule Akedia.Plugs.PlugMicrosub.HandlerBehaviour do
  @moduledoc """
  Behaviour defining the interface for a PlugMicrosub Handler
  """

  @type access_token :: String.t()
  @type handler_error_atom :: :invalid_request | :forbidden | :insufficient_scope
  @type handler_error ::
          {:error, handler_error_atom} | {:error, handler_error_atom, description :: String.t()}

  @callback handle_list_channels() :: {:ok, map} | handler_error

  @callback handle_timeline(
              channel :: String.t(),
              paging_before :: String.t(),
              paging_after :: String.t()
            ) :: {:ok, list, map} | handler_error
end
