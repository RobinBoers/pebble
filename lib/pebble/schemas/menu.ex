defmodule Pebble.Menu do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  import Pebble,
    only: [
      fetch_menu_categories: 1,
      fetch_menu_items: 1
    ]

  alias Pebble.Menu.Item
  alias Pebble.Menu.Category
  alias Pebble.Site

  embedded_schema do
    embeds_many :items, Item
    embeds_many :categories, Category
  end

  def changeset_for(%Site{} = site, params \\ %{}) do
    %__MODULE__{
      items: fetch_menu_items(site),
      categories: fetch_menu_categories(site)
    }
    |> changeset(params)
  end

  def changeset(schema \\ %__MODULE__{}, params) do
    schema
    |> cast(params, [])
    |> cast_embed(:items, with: &Item.changeset/2)
    |> cast_embed(:categories, with: &Category.changeset/2)
  end
end
