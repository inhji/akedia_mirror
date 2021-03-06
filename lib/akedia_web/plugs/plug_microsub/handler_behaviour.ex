defmodule AkediaWeb.Plugs.PlugMicrosub.HandlerBehaviour do
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

  @callback handle_mark_read(
              channel :: String.t(),
              entry_ids :: list
            ) :: :ok | handler_error

  @callback handle_mark_read_before(
              channel :: String.t(),
              before_id :: String.t()
            ) :: :ok | handler_error

  # @callback handle_mark_unread(
  #             channel :: String.t(),
  #             entry_ids :: list
  #           )

  # @callback handle_mark_read_before(
  #             channel :: String.t(),
  #             entry_id :: String.t()
  #           )
end
