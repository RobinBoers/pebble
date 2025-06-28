defmodule Pebble.Context do
  @moduledoc """
  Stores site-specific data for a template.

  There are some properties of a template that might change depending
  on the site the template is being rendered on. Primarily:

  - The layout to use (since layouts cannot be shared across sites)
  - The route on which the template will be rendered.

  This schema is required because Ecto does not support storing data
  on the edges (ie. join tables) between many-to-many relations.
  """
  use Ecto.TypedSchema

  alias Pebble.Site
  alias Pebble.Template
  alias Pebble.Layout

  import Ecto.Changeset

  # Usually, you'd have `@primary_key false` on these kind of
  # edge tables, but since Ecto is being a crybaby otherwise,
  # we have a surrogate key now.

  schema "templates_sites" do
    field :route, :string

    belongs_to :layout, Layout
    belongs_to :site, Site
    belongs_to :template, Template
  end

  def changeset_for(%Template{id: template_id}, params \\ %{}) do
    changeset(%__MODULE__{template_id: template_id}, params)
  end

  def changeset(settings \\ %__MODULE__{}, params \\ %{}) do
    # The `template_id` is of course required in every row, but since
    # these rows are inserted as part of the `Pebble.Template` changeset,
    # we cannot mark it as required here, as that would break inserts.

    settings
    |> cast(params, [:route, :site_id, :layout_id])
    |> validate_required([:route, :site_id])
    |> unique_constraint(:route)
    |> unique_constraint([:site_id, :template_id])
  end
end
