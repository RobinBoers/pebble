defmodule Pebble.Template do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Pebble.Site

  @types [:heex, :md, :plain]

  schema "templates" do
    field :label, :string
    field :route, :string
    field :content, :string
    field :type, Ecto.Atom

    many_to_many :sites, Site, join_through: "templates_sites"

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