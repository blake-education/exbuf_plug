defmodule ExbufPlugTest do
  require IEx
  use ExUnit.Case
  use Plug.Test
  doctest ExbufPlug

  @opts ExbufPlug.init([param_key: "event"])

  @awesomer_event "CAE="
  @sucker_event "CAI="

  test "happy path" do
    conn = conn("post", "/anything", %{event: @sucker_event})
      |> put_req_header("x-protobuf", "TestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.TestEvent{
      title: :sucker,
    }

    conn = conn("post", "/anything", %{event: @awesomer_event})
      |> put_req_header("x-protobuf", "TestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.TestEvent{
      title: :awesomer,
    }
  end

  test "invalid event params body" do
    base64 = "boo"

    conn = conn("post", "/anything", %{event: base64})
      |> put_req_header("x-protobuf", "TestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.status == 400
  end

  test "no x-prototype header" do
    conn = conn("post", "/anything", %{event: @sucker_event})
      |> ExbufPlug.call(@opts)

    assert conn.status == 400
  end

  test "more complex protobuf" do
    base64 = "CAISCEJpbGwgTnllGg9UaGUgc2NpZW5jZSBndXk="

    conn = conn("post", "/anything", %{event: base64})
      |> put_req_header("x-protobuf", "BiggerTestEvent")
      |> ExbufPlug.call(@opts)

    assert conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.BiggerTestEvent{
      title: :sucker,
      name: "Bill Nye",
      desc: "The science guy"
    }
  end
end
