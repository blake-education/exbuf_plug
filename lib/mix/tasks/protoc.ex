defmodule Mix.Tasks.ExbufPlug.Protoc do
  use Mix.Task

  @shortdoc "Generate the protobuf modules from blake.proto"

  def run(_) do
    args = [
      "--elixir_out=../../lib",
      "--elixir_opt=package_prefix=exbuf_plug.protobufs,include_docs=true",
      "buffs.proto"
    ]

    {_, 0} = System.cmd("protoc", args, cd: "test/helpers")
  end
end
