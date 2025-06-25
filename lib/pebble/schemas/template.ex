defmodule Pebble.Template do
  @moduledoc false
  use Ecto.TypedSchema

  alias Pebble.Site

  import Ecto.Changeset

  def types, do: [:heex, :md, :plain]
  def visibility, do: [:draft, :hidden, :rss, :public]

  typed_schema "templates" do
    field :label, :string
    field :content, :string
    field :type, Ecto.Atom
    field :visibility, Ecto.Atom

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
    |> validate_format(:route, ~r|^/|, message: "must start with '/'")
    |> validate_inclusion(:type, types())
    |> validate_inclusion(:visibility, visibility())
    |> unique_constraint(:route)
  end
end
