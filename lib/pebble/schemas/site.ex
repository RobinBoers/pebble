defmodule Pebble.Site do
  @moduledoc false
  use Ecto.Schema

  alias Pebble.Fragment
  alias Pebble.Template
  alias Pebble.Menu.Category
  alias Pebble.Menu.Item

  schema "sites" do
    field :pebble_hostname, :string
    field :vik_hostname, :string
    field :scry_hostname, :string

    many_to_many :menu_categories, Category, join_through: "categories_sites"
    many_to_many :menu_items, Item, join_through: "items_sites"
    many_to_many :fragments, Fragment, join_through: "fragments_sites"
    many_to_many :templates, Template, join_through: "templates_sites"

    timestamps()
  end
end