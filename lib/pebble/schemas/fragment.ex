defmodule Pebble.Fragment do
  @moduledoc """
  Blobs of well-defined JSON data, as outlined by a `Pebble.Schema`.
  """
  use Ecto.TypedSchema

  alias Pebble.Schema
  alias Pebble.Site

  typed_schema "fragments" do
    field :data, :string

    belongs_to :schema, Schema
    many_to_many :sites, Site, join_through: "fragments_sites"

    timestamps()
  end
end
