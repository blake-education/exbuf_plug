use Mix.Config

config :exbuf_plug, ExbufPlug, %{
  list: [],
  namespace: "ExbufPlug",
  module_name: "Protobufs",
  header_name: "x-protobuf"
}
