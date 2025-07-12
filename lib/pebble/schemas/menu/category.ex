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

  import Ecto.Changeset

  typed_schema "menu_categories" do
    field :label, :string
    field :order, :integer, default: 0

    has_many :items, Item
    many_to_many :sites, Site, join_through: "categories_sites"

    timestamps()
  end

  def changeset_for(%Site{} = site, params \\ %{}) do
    changeset(%__MODULE__{sites: [site]}, params)
  end

  def changeset(schema \\ %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:label, :order])
    |> validate_required([:label])
    |> validate_number(:order, greater_than_or_equal_to: 0)
  end
end
