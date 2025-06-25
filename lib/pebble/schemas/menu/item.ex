defmodule Pebble.Menu.Item do
  @moduledoc """
  Represents a menu item to be rendered on a site.

  A menu item consists of a label and a route. The
  route can either be an external URL or an internal
  path.

  Internal paths will be validated to exists for one or more
  `Pebble.Template` instances. If their routes change, a 
  warning will be shown on the dashboard to indicate that a 
  menu item is now linking to a non-existing path.
  """
  use Ecto.TypedSchema

  alias Pebble.Menu.Category
  alias Pebble.Site

  typed_schema "menu_items" do
    field :label, :string
    field :route, :string # either path or URL
    field :order, :integer
    field :selected, :boolean, virtual: true

    belongs_to :category, Category, foreign_key: :category_id
    many_to_many :sites, Site, join_through: "items_sites"

    timestamps()
  end
end