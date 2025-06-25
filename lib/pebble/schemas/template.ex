defmodule Pebble.Template do
  @moduledoc false
  use Ecto.TypedSchema

  alias Pebble.Site

  import Ecto.Changeset

  @types [:heex, :md, :plain]

  typed_schema "templates" do
    field :label, :string
    field :route, :string
    field :content, :string
    field :type, Ecto.Atom

    # Will contain %Layout{} for the current site if populated.
    field :layout, :map, virtual: true

    has_many :template_sites, Pebble.TemplateSite, on_replace: :delete
    has_many :sites, through: [:template_sites, :site]

    timestamps()
  end

  def changeset_for(%Site{id: site_id}, params \\ %{}) do
    l = [%Pebble.TemplateSite{site_id: site_id}]
    changeset(%__MODULE__{template_sites: l}, params)
  end

  def changeset(template \\ %__MODULE__{}, params \\ %{}) do
    template
    |> cast(params, [:label, :route, :type])
    |> cast_assoc(:template_sites, required: true)
    |> validate_required([:label, :route, :type])
    |> validate_format(:route, ~r|^/|, message: "must start with '/'")
    |> validate_inclusion(:type, @types)
    |> unique_constraint(:route)
  end
end