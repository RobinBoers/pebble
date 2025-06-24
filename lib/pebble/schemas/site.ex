defmodule Pebble.Site do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Pebble.Fragment
  alias Pebble.Template
  alias Pebble.Menu.Category
  alias Pebble.Menu.Item

  @derive {Phoenix.Param, key: :hostname}

  schema "sites" do
    field :hostname, :string
    field :vik_hostname, :string
    field :scry_hostname, :string

    many_to_many :menu_categories, Category, join_through: "categories_sites"
    many_to_many :menu_items, Item, join_through: "items_sites"
    many_to_many :fragments, Fragment, join_through: "fragments_sites"
    many_to_many :templates, Template, join_through: "templates_sites"

    timestamps()
  end

  def changeset(site \\ %__MODULE__{}, params \\ %{}) do
    site
    |> cast(params, [:hostname, :vik_hostname, :scry_hostname])
    |> validate_required([:hostname])
    |> unique_constraint([:hostname])
  end

  defimpl String.Chars do
    @moduledoc false
    def to_string(%@for{hostname: str}), do: str
  end

  defimpl Phoenix.HTML.Safe do
    @moduledoc false
    def to_iodata(%@for{hostname: str}), do: str
  end
end