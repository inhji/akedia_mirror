defmodule Akedia.Plugs.PlugMicrosub do
  @moduledoc """
  A plug for building a Microsub server.
  """
  use Plug.Router
  require Logger

  @supported_actions ["channels", "timeline"]
  @supported_methods ["delete", "mark_read", "mark_unread"]

  @param_entry "entry"
  @param_last_read "last_read_entry"

  plug(:match)
  plug(:dispatch)

  def init(opts) do
    handler =
      Keyword.get(opts, :handler) || raise ArgumentError, "Microsub Plug requires :handler option"

    json_encoder =
      Keyword.get(opts, :json_encoder) ||
        raise ArgumentError, "Microsub Plug requires :json_encoder option"

    [handler: handler, json_encoder: json_encoder]
  end

  def call(conn, opts) do
    conn = put_private(conn, :plug_microsub, opts)
    super(conn, opts)
  end

  get "/" do
    Logger.debug("Handling GET Request")

    with {:ok, action, conn} <- get_action(conn) do
      handle_action(conn, :get, action)
    else
      {:error, reason} ->
        send_error(conn, reason)
    end
  end

  post "/" do
    Logger.debug("Handling POST Request")

    with {:ok, action, conn} <- get_action(conn),
         {:ok, method, conn} <- get_method(conn) do
      Logger.debug("Action: #{action}")
      Logger.debug("Method: #{method}")

      if is_nil(method) do
        handle_action(conn, :post, action)
      else
        handle_action(conn, :post, action, method)
      end
    else
      {:error, reason} ->
        Logger.error(reason)
        send_error(conn, reason)
    end
  end

  match _ do
    IO.inspect(conn)
    Logger.debug("Unknown route!")
    send_resp(conn, 404, "Not found!")
  end

  def handle_action(conn, :get, :channels) do
    handler = get_opt(conn, :handler)

    with {:ok, channels} <- handler.handle_list_channels() do
      conn
      |> send_response(%{channels: channels})
    else
      {:error, code, reason} ->
        send_error(conn, reason, code)
    end
  end

  def handle_action(conn, :post, :timeline, :mark_read) do
    Logger.debug("Timeline/MarkRead")

    cond do
      get_param!(conn, @param_entry) != nil ->
        entry_ids = get_param!(conn, @param_entry)
        handle_mark_read(conn, entry_ids)

      get_param!(conn, @param_last_read) != nil ->
        last_read_entry = get_param!(conn, @param_last_read)
        # TODO
        send_error(conn, "Not implemented")
    end
  end

  def handle_mark_read(conn, entry_ids) do
    handler = get_opt(conn, :handler)

    with {:ok, channel} <- get_param(conn, "channel"),
         entry_ids <- maybe_wrap_entry_ids(entry_ids),
         :ok <- handler.handle_mark_read(channel, entry_ids) do
      send_response(conn)
    else
      {:error, reason} ->
        Logger.debug("Timeline/MarkRead: #{reason}")
        send_error(conn, reason)
    end
  end

  def maybe_wrap_entry_ids(entry_ids) do
    case is_list(entry_ids) do
      true -> entry_ids
      false -> [entry_ids]
    end
  end

  def handle_action(conn, :post, :timeline, :mark_unread) do
    send_response(conn, [])
  end

  def handle_action(conn, :get, :timeline) do
    handler = get_opt(conn, :handler)

    with {:ok, channel} <- get_param(conn, "channel"),
         {:ok, page_before, page_after} <- validate_paging(conn),
         {:ok, items, paging} <- handler.handle_timeline(channel, page_before, page_after) do
      send_response(conn, %{
        items: items,
        paging: paging
      })
    else
      {:error, reason} ->
        send_error(conn, reason)
    end
  end

  def handle_action(conn, _, _) do
    send_error(conn, "Bad Request (Catchall)")
  end

  def validate_paging(conn) do
    page_before = get_param!(conn, "before")
    page_after = get_param!(conn, "after")

    cond do
      is_nil(page_before) and is_nil(page_after) ->
        {:ok, nil, nil}

      is_nil(page_before) and not is_nil(page_after) ->
        {:ok, nil, String.to_integer(page_after)}

      not is_nil(page_before) and is_nil(page_after) ->
        {:ok, String.to_integer(page_before), nil}

      true ->
        {:error, "Bad Paging information"}
    end
  end

  def get_action(%{query_params: %{"action" => action}} = conn) do
    if not Enum.member?(@supported_actions, action) do
      {:error, "Unsupported action"}
    else
      {:ok, String.to_atom(action), conn}
    end
  end

  def get_action(%{params: %{"action" => action}} = conn) do
    if not Enum.member?(@supported_actions, action) do
      {:error, "Unsupported action"}
    else
      {:ok, String.to_atom(action), conn}
    end
  end

  def get_action(%{query_params: _} = conn) do
    Logger.error("Could not find action parameter")
    {:error, "Bad Request"}
  end

  def get_method(%{query_params: %{"method" => method}} = conn) do
    if not Enum.member?(@supported_methods, method) do
      {:error, "Unsupported method"}
    else
      {:ok, String.to_atom(method), conn}
    end
  end

  def get_method(%{params: %{"method" => method}} = conn) do
    if not Enum.member?(@supported_methods, method) do
      {:error, "Unsupported method"}
    else
      {:ok, String.to_atom(method), conn}
    end
  end

  def get_method(conn) do
    {:ok, nil, conn}
  end

  def get_param(conn, param_name) do
    case get_param!(conn, param_name) do
      nil -> {:error, "Parameter #{param_name} not found!"}
      value -> {:ok, value}
    end
  end

  def get_param!(conn, param_name) do
    Enum.reduce_while(
      [
        &maybe_get_from_query_params/2,
        &maybe_get_from_body_params/2
      ],
      nil,
      fn strategy, acc ->
        case strategy.(conn, param_name) do
          nil ->
            Logger.debug("Nothing found for #{param_name}")
            {:cont, acc}

          value ->
            Logger.debug("Value found for #{param_name}")
            {:halt, value}
        end
      end
    )
  end

  def maybe_get_from_query_params(%{:query_params => params}, param_name) do
    Map.get(params, param_name)
  end

  def maybe_get_from_body_params(%{:body_params => params}, param_name) do
    Map.get(params, param_name)
  end

  def get_opt(conn, opt) do
    conn.private[:plug_microsub][opt]
  end

  def send_response(conn, response) do
    json_encoder = get_opt(conn, :json_encoder)
    body = json_encoder.encode!(response)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:ok, body)
  end

  def send_response(conn) do
    send_response(conn, %{})
  end

  def send_error(conn, reason, code \\ :invalid_request) do
    json_encoder = get_opt(conn, :json_encoder)
    error_code = get_error_code(code)

    body =
      json_encoder.encode!(%{
        error: reason
      })

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(error_code, body)
  end

  def get_error_code(:insufficient_scope), do: :unauthorized
  def get_error_code(:invalid_request), do: :bad_request
  def get_error_code(code), do: code
end
