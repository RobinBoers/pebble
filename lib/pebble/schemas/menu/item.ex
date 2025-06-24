defmodule Pebble.Menu.Item do
  @moduledoc false
  use Ecto.Schema

  # TODO(robin): we need validation on routes. aka i should
  # check if the specified route matches anything in the
  # templates section. if not, show a warning. do this 
  # whenever the routes in the templates section change.

  alias Pebble.Menu.Category
  alias Pebble.Site

  schema "menu_items" do
    field :label, :string
    field :route, :string # either path or URL
    field :order, :integer
    field :selected, :boolean, virtual: true

    belongs_to :category, Category, foreign_key: :category_id
    many_to_many :sites, Site, join_through: "items_sites"

    timestamps()
  end
end