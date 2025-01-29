defmodule ExbufPlug.Protobufs.AllowedTitles do
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.14.0", syntax: :proto2

  field :awesomer, 1
  field :sucker, 2
end

defmodule ExbufPlug.Protobufs.TestEvent do
  use Protobuf, protoc_gen_elixir_version: "0.14.0", syntax: :proto2

  field :title, 1, required: true, type: ExbufPlug.Protobufs.AllowedTitles, enum: true
end

defmodule ExbufPlug.Protobufs.BiggerTestEvent do
  use Protobuf, protoc_gen_elixir_version: "0.14.0", syntax: :proto2

  field :title, 1, required: true, type: ExbufPlug.Protobufs.AllowedTitles, enum: true
  field :name, 2, required: true, type: :string
  field :desc, 3, required: true, type: :string
end
