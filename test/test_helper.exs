defmodule ExbufPlug.Protobufs do
  @external_resource Path.expand("./helpers/buffs.proto", __DIR__)

  use Protobuf, from: Path.expand("./helpers/buffs.proto", __DIR__)
end

ExUnit.start()
