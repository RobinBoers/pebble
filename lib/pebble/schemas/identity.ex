defmodule Pebble.Identity do
  @moduledoc """
  The identity defines an object of globally available variables
  within all templating in a `Pebble.Site`, along with a schema
  well-defining it.
  """
  use Ecto.TypedSchema

  alias Pebble.Schema
  alias Pebble.Site
  alias Pebble.Changeset

  import Ecto.Changeset

  typed_schema "identity" do
    field :data, :string
    field :definition, :string
    belongs_to :site, Site

    # Contains the parsed TOML data if populated.
    field :fields, {:array, :map}, virtual: true

    timestamps()
  end

  def changeset_for(%Changeset{sites: [site]} = changeset, params \\ %{}) do
    %__MODULE__{id: changeset.id, site: site}
    |> changeset(%{"data" => JSON.encode!(params)})
  end

  def changeset(identity \\ %__MODULE__{}, params \\ %{}) do
    identity
    |> cast(params, [:data, :definition])
    |> cast_assoc(:site, required: true)
    |> validate_required([:definition])
    |> validate_schema(:definition)
  end

  defp validate_schema(changeset, field) when is_atom(field) do
    validate_schema(changeset, field, get_field(changeset, field))
  end

  defp validate_schema(changeset, _, d) when d in [nil, ""] do
    changeset
  end

  defp validate_schema(changeset, field, definition) do
    case Schema.validate(definition) do
      :ok ->
        changeset

      {:error, errors} when is_list(errors) ->
        Enum.reduce(errors, changeset, &add_error(&2, field, &1))

      {:error, error} ->
        add_error(changeset, field, error)
    end
  end
end
