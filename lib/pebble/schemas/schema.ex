defmodule Pebble.Schema do
  @moduledoc false
  use Ecto.Schema

  schema "schemas" do
    field :label, :string
    field :definition, :string

    timestamps()
  end
end