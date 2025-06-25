defmodule Pebble.TemplateSite do
  @moduledoc """
  This schema is required because Ecto does not support
  storing data on the edges between many-to-many relations.

  In our case, the layout of a site can differ per site, so
  we need to store the relation on the join table, which is
  represented by this schema to work around the Ecto limitation.

  This is an irrelevant implementation detail.
  Please forget about it.
  """
  use Ecto.TypedSchema
  import Ecto.Changeset

  alias Pebble.Site
  alias Pebble.Template
  alias Pebble.Layout

  # Usually, you'd have `@primary_key false` on these kind of
  # edge tables, but since Ecto is being a crybaby otherwise,
  # we have a surrogate key now.

  schema "templates_sites" do
    belongs_to :site, Site
    belongs_to :template, Template
    belongs_to :layout, Layout
  end

  def changeset(template_site, attrs) do
    # The `template_id` is of course required in every row, but since
    # these rows are inserted as part of the `Pebble.Template` changeset,
    # we cannot mark it as required here, as that would break inserts.

    template_site
    |> cast(attrs, [:site_id, :template_id, :layout_id])
    |> validate_required([:site_id])
    |> assoc_constraint(:site)
    |> assoc_constraint(:layout)
    |> unique_constraint([:site_id, :template_id])
  end
end