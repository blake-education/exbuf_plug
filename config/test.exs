use Mix.Config

config :exbuf_plug, ExbufPlug, %{
  list: [
    "TestEvent",
    "BiggerTestEvent"
  ],
  namespace: "ExbufPlug",
  module_name: "Protobufs",
  header_name: "x-protobuf"
}
