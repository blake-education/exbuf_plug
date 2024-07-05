defmodule ExbufPlug do
  @moduledoc """
  A plug to convert request information into protobufs

  We look for a header called `x-protobuf` and a binary body.
  We decode these into application specific protobufs to be used throughout the rest of the request
  """
  import Plug.Conn

  # config :exbuf_plug, ExbufPlug, %{
  #   list: [
  #     "TestEvent",
  #     "BiggerTestEvent"
  #   ],
  #   namespace: "ExbufPlug",
  #   module_name: "Protobufs",
  #   header_name: "x-protobuf"
  # }
  @protoconfig Application.compile_env(:exbuf_plug, ExbufPlug)
  @protobufs @protoconfig.list
  @protobufs_namespace @protoconfig.namespace
  @protobufs_module @protoconfig.module_name
  @protobufs_header @protoconfig.header_name

  @doc """
  We fetch param_key from options
  With this params_key we use it to fetch in the base64 string from the plug's `params`
  """
  def init(options), do: options

  def call(conn, _options) do
    with {:ok, decoder} <- protobuf_struct(proto_type(conn)) do
      content_type = content_type(conn)

      case decode_into_proto_struct(content_type, conn, decoder) do
        {:ok, proto_structs} when is_list(proto_structs) ->
          conn
          |> assign(:protobuf_structs, proto_structs)

        {:ok, proto_struct} ->
          conn
          |> assign(:protobuf_struct, proto_struct)
      end
    else
      {:error, error} ->
        conn
        |> send_resp(400, error)
        |> halt
    end
  end

  defp content_type(conn) do
    with [content_type | _] <- Plug.Conn.get_req_header(conn, "content-type"),
         {:ok, type, _subtype, _params} <- Plug.Conn.Utils.content_type(content_type) do
      type
    else
      [] -> "absent"
      :error -> "parse-error"
    end
  end

  defp decode_into_proto_struct("multipart", %{params: params}, decoder) do
    decoded_protobufs =
      params
      |> Enum.map(fn {_k, encoded_protobuf} -> decoder.decode(encoded_protobuf) end)

    {:ok, decoded_protobufs}
  end

  defp decode_into_proto_struct(_content_type, conn, decoder) do
    case read_body(conn) do
      {:ok, binary, _conn} -> {:ok, decoder.decode(binary)}
      error -> error
    end
  end

  defp protobuf_struct(proto_type) do
    case Enum.find(@protobufs, &(&1 == proto_type)) do
      nil ->
        {:error, "invalid protobuf type: #{proto_type}"}

      _protobuf ->
        {:ok, :"Elixir.#{@protobufs_namespace}.#{@protobufs_module}.#{proto_type}"}
    end
  end

  defp proto_type(conn) do
    conn
    |> get_req_header(@protobufs_header)
    |> List.first()
  end
end
