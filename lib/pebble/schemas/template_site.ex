defmodule Pebble.SiteTemplate do
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

  @primary_key false
  schema "templates_sites" do
    belongs_to :site, Site
    belongs_to :template, Template
    belongs_to :layout, Layout
  end

  def changeset(template_site, attrs) do
    template_site
    |> cast(attrs, [:site_id, :template_id, :layout_id])
    |> validate_required([:site_id, :template_id])
    |> assoc_constraint(:site)
    |> assoc_constraint(:template)
    |> assoc_constraint(:layout)
    |> unique_constraint([:site_id, :template_id])
  end
end