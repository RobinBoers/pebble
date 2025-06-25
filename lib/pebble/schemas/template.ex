defmodule Pebble.Template do
  @moduledoc false
  use Ecto.TypedSchema

  import Ecto.Changeset

  @types [:heex, :md, :plain]

  typed_schema "templates" do
    field :label, :string
    field :route, :string
    field :content, :string
    field :type, Ecto.Atom

    has_many :template_sites, Pebble.TemplateSite
    has_many :sites, through: [:template_sites, :site]

    timestamps()
  end

  def changeset(template \\ %__MODULE__{}, params \\ %{}) do
    template
    |> cast(params, [:label, :route, :type])
    |> cast_assoc(:sites, required: true)
    |> validate_required([:label, :route, :type])
    |> validate_format(:route, ~r|^/|, message: "must start with '/'")
    |> validate_inclusion(:type, @types)
    |> unique_constraint(:route)
  end
end