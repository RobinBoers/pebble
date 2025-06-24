defmodule Pebble.Asset do
  @moduledoc false
  use Ecto.Schema

  schema "assets" do
    field :url, :string
    field :alt, :string
    field :filename, :string

    timestamps()
  end
end