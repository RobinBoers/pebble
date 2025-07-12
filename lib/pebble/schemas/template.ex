defmodule Pebble.Template do
  @moduledoc """
  A template defines the dynamically generated HTML to be
  rendered on a specified route.
  """
  use Ecto.TypedSchema

  alias Pebble.Site

  import Ecto.Changeset

  @types [:html, :md, :plain]
  @visibilities [:draft, :hidden, :rss, :public]

  @doc "Supported render types."
  def types, do: @types

  @doc "Supported visibilities."
  def visibility, do: @visibilities

  typed_schema "templates" do
    field :label, :string
    field :content, :string
    field :type, Ecto.Enum, values: @types
    field :visibility, Ecto.Enum, values: @visibilities

    # Will contain %Layout{} and route for the current site if populated.
    field :route, :string, virtual: true
    field :layout, :map, virtual: true

    has_many :linked_sites, Pebble.Context, on_replace: :delete
    has_many :sites, through: [:linked_sites, :site]

    timestamps()
  end

  def changeset_for(%Site{id: site_id}, params \\ %{}) do
    s = [%Pebble.Context{site_id: site_id}]
    changeset(%__MODULE__{linked_sites: s}, params)
  end

  def changeset(template \\ %__MODULE__{}, params \\ %{}) do
    template
    |> cast(params, [:label, :content, :type, :visibility])
    |> cast_assoc(:linked_sites, required: true)
    |> validate_required([:label, :type])
    |> validate_inclusion(:type, types())
    |> validate_inclusion(:visibility, visibility())
  end
end
