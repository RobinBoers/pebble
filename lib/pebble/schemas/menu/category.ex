defmodule Pebble.Menu.Category do
  @moduledoc false
  use Ecto.TypedSchema

  alias Pebble.Menu.Item
  alias Pebble.Site

  typed_schema "menu_categories" do
    field :label, :string

    has_many :items, Item
    many_to_many :sites, Site, join_through: "categories_sites"

    timestamps()
  end
end
