defmodule Akedia.Plugs.PlugMicrosub do
  @moduledoc """
  A plug for building a Microsub server.
  """
  use Plug.Router
  require Logger

  @supported_actions ["channels", "timeline"]
  @supported_methods ["delete", "mark_read", "mark_unread"]

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
    with {:ok, action, conn} <- get_action(conn) do
      handle_action(conn, :get, action)
    else
      {:error, reason} ->
        send_error(conn, reason)
    end
  end

  post "/" do
    with {:ok, action, conn} <- get_action(conn),
         {:ok, method, conn} <- get_method(conn) do
      if is_nil(method) do
        handle_action(conn, :post, action)
      else
        handle_action(conn, :post, action, method)
      end
    else
      {:error, reason} ->
        send_error(conn, reason)
    end
  end

  match _ do
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
    cond do
      get_query_param!(conn, "entry_id") != nil ->
        entry_ids = get_query_param!(conn, "entry_id")
        handle_mark_read(conn, entry_ids)

      get_query_param!(conn, "last_read_entry") != nil ->
        last_read_entry = get_query_param!(conn, "last_read_entry")
        # TODO
        send_error(conn, "Not implemented")
    end
  end

  def handle_mark_read(conn, entry_ids) do
    handler = get_opt(conn, :handler)

    with {:ok, channel} <- get_query_param(conn, "channel"),
         entry_ids <- maybe_wrap_entry_ids(entry_ids),
         :ok <- handler.handle_mark_read(channel, entry_ids) do
      send_response(conn)
    else
      {:error, reason} ->
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

    with {:ok, channel} <- get_query_param(conn, "channel"),
         {:ok, page_before, page_after} <- validate_paging(conn),
         {:ok, items, paging} <- handler.handle_timeline(channel, page_before, page_after) do
      send_response(conn, %{})
    else
      {:error, reason} ->
        send_error(conn, reason)
    end
  end

  # def handle_action(conn, _, _) do
  #   send_error(conn, "Bad Request (Catchall)")
  # end

  def validate_paging(conn) do
    page_before = get_query_param!(conn, "before")
    page_after = get_query_param!(conn, "after")

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

  def get_action(%{query_params: _}), do: {:error, "Bad Request"}

  def get_method(%{query_params: _params} = conn) do
    with method <- get_query_param!(conn, "method"),
         {:ok, method} <- validate_method(method) do
      {:ok, String.to_atom(method), conn}
    else
      error -> error
    end
  end

  def validate_method(nil), do: {:ok, nil}

  def validate_method(method) do
    IO.inspect("Validating method #{inspect(method)}")

    if not Enum.member?(@supported_methods, method) do
      {:error, "Unsupported method"}
    else
      {:ok, method}
    end
  end

  def get_query_param(%{:query_params => params}, param_name) do
    case Map.fetch(params, param_name) do
      {:ok, value} -> {:ok, value}
      :error -> {:error, "Param #{param_name} missing"}
    end
  end

  def get_query_param!(conn, param_name) do
    case get_query_param(conn, param_name) do
      {:ok, value} -> value
      {:error, _} -> nil
    end
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
