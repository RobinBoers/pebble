defmodule Pebble.Fragment do
  @moduledoc false
  use Ecto.Schema

  alias Pebble.Schema
  alias Pebble.Site

  schema "fragments" do
    field :data, :string

    belongs_to :schema, Schema
    many_to_many :sites, Site, join_through: "fragments_sites"

    timestamps()
  end
end
