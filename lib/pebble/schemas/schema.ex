defmodule Pebble.Schema do
  @moduledoc false
  use Ecto.TypedSchema

  typed_schema "schemas" do
    field :label, :string
    field :definition, :string

    timestamps()
  end
end