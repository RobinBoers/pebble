defmodule Pebble.Menu.Category do
  @moduledoc """
  Represents a category in the menu for a site.

  A category can contain one or more menu items. If the
  category has no menu items, it will not be rendered on
  the site.
  """
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
