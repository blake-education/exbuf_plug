ExbufPlug
========

A small plug to handle decoding protocol buffers.

ExbufPlug is a wrapper around [exprotobuf](https://github.com/bitwalker/exprotobuf) to handle dealing with
protobufs over http.

The strategy here is to decode a protocol buffer into binary and send it over http - which this plug will
decode into an elixir struct to deal with in your application.

## Useful articles

* [What are protocol buffers](https://developers.google.com/protocol-buffers/)
* [Why use protocol buffers over json](http://blog.codeclimate.com/blog/2014/06/05/choose-protocol-buffers/)

## Installation

Add ExbufPlug to your application

mix.deps

```elixir
defp deps do
  [
    # ...
    {:exbuf_plug, "~> 0.0.1"}
    # ...
  ]
end
```

config.exs

```elixir
config :exbuf_plug, ExbufPlug, %{
  list: [
    "TestEvent",
    "BiggerTestEvent"
  ],
  namespace: "ExbufPlug",
  module_name: "Protobufs",
  header_name: "x-protobuf"
}
```

The items in the configuration allow you to tailor how the decoding behaves.

* `list` - The list of protobufs currently supported
* `namespace` - The namespace around the protobuf module.
* `module_name` - The main module that implements `exprotobuf` to be used for encoding/decoding protobufs.
* `header_name` - The header name to look for to know which protobuf to use for decoding

Given the config above, ExbufPlug will attempt to decode the protobuf using the module `ExbufPlug.Protobufs`.

A simple example might look like this.

```elixir
defmodule ExbufPlug.Protobufs do
  use Protobuf, from: Path.expand("./protocol_buffers.proto", __DIR__)
end
```


## Phoenix Controllers

ExbufPlug hooks easily into Phoenix controllers.

The decoded value will assigned to the `conn.protobuf_struct` for your use throughout the request.

```elixir
defmodule MyApp.MyController do
  use MyApp.Web, :controller

  plug ExbufPlug

  def show(conn, _params) do
    conn.assigns.protobuf_struct
  end
end
```

### Small Example

Given the sample protobuf schema we can see a typical flow through the usage.

```proto
enum AllowedTitles {
  awesomer = 1;
  sucker = 2;
}

message TestEvent {
  required AllowedTitles title = 1;
  required string name = 2;
  required string desc = 3;
}
```

We can get the encoded version of this protobuf with the following

```elixir
# encode protobuf and encode into base64
base64 = Protobuf.TestEvent.new(
  title: :awesomer,
  name: "Bill Nye",
  desc: "The science guy"
)
|> Protobuf.TestEvent.encode
# <<8, 2, 18, 8, 66, 105, 108, 108, 32, 78, 121, 101, 26, 15, 84, 104, 101, 32, 115, 99, 105, 101, 110, 99, 101, 32, 103, 117, 121>>
```

With this binary, we can post this over HTTP. Imagine some language sending this post to create an event.

```elixir
# not real code.. :troll:
client = HttpThing.new(host: "http://localhost:4000")
client.post(
  "api/v3/event",
  { body: <<8, 2, 18, 8, 66, 105, 108, 108, 32, 78, 121, 101, 26, 15, 84, 104, 101, 32, 115, 99, 105, 101, 110, 99, 101, 32, 103, 117, 121>> },
  { headers: [
    {"Content-Type": "application/octet-stream"}
    {"x-protobuf": "TestEvent"}
  ]},
)
```

In elixir it would be better to deal with the protobuf struct, so by adding this plug into any plug app, we can easily deal with
pure elixir structs.

```elixir
defmodule MyApp.MyController do
  use MyApp.Web, :controller

  plug ExbufPlug

  def show(conn, _params) do
    conn.assigns.protobuf_struct == %ExbufPlug.Protobufs.TestEvent{
      title: :sucker,
      name: "Bill Nye",
      desc: "The science guy"
    }
  end
end
```
