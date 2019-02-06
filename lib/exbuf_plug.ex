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
  @protoconfig Application.get_env(:exbuf_plug, ExbufPlug)
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
    case decode_into_proto_struct(conn) do
      proto_struct when is_map(proto_struct) ->
        conn
        |> assign(:protobuf_struct, proto_struct)

      _ ->
        conn
        |> send_resp(400, "invalid request params.")
        |> halt
    end
  end

  def decode_into_proto_struct(conn) do
    case fetch_binary(conn) do
      {:ok, binary, conn} ->
        case protobuf_struct(proto_type(conn)) do
          {:ok, decoder} ->
            decoder.decode(binary)

          _ ->
            :error
        end

      _ ->
        :error
    end
  end

  defp fetch_binary(conn) do
    conn
    |> read_body
  end

  defp protobuf_struct(proto_type) do
    case Enum.find(@protobufs, &(&1 == proto_type)) do
      nil ->
        {:error, "invalid protobuf type"}

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
