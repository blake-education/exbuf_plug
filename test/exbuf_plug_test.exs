defmodule ExbufPlugTest do
  use ExUnit.Case
  use Plug.Test
  doctest ExbufPlug

  @opts ExbufPlug.init([])

  defp build_binary(struct, values) do
    struct.new(values)
    |> struct.encode
  end

  def awesomer_event do
    build_binary(ExbufPlug.Protobufs.TestEvent, title: :awesomer)
  end

  def sucker_event do
    build_binary(ExbufPlug.Protobufs.TestEvent, title: :sucker)
  end

  test "happy path" do
    conn = conn("post", "/anything", sucker_event)
      |> put_req_header("content-type", "application/octet-stream")
      |> put_req_header("x-protobuf", "TestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.TestEvent{
      title: :sucker,
    }

    conn = conn("post", "/anything", awesomer_event)
      |> put_req_header("content-type", "application/octet-stream")
      |> put_req_header("x-protobuf", "TestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.TestEvent{
      title: :awesomer,
    }
  end

  test "nil binary body returns nil/default struct" do
    conn = conn("post", "/anything", nil)
      |> put_req_header("content-type", "application/octet-stream")
      |> put_req_header("x-protobuf", "TestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.TestEvent{
      title: nil,
    }
  end

  test "no x-prototype header" do
    conn = conn("post", "/anything", sucker_event)
      |> put_req_header("content-type", "application/octet-stream")
      |> ExbufPlug.call(@opts)

    assert conn.status == 400
  end

  test "more complex protobuf" do
    binary = build_binary(
      ExbufPlug.Protobufs.BiggerTestEvent,
      title: :sucker,
      name: "Bill Nye",
      desc: "The science guy"
    )

    conn = conn("post", "/anything", binary)
      |> put_req_header("x-protobuf", "BiggerTestEvent")
      |> put_req_header("content-type", "application/octet-stream")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.BiggerTestEvent{
      title: :sucker,
      name: "Bill Nye",
      desc: "The science guy"
    }
  end
end
