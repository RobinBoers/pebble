defmodule Pebble.Fragment do
  @moduledoc """
  Blobs of well-defined JSON data, as outlined by a `Pebble.Schema`.
  """
  use Ecto.TypedSchema

  alias Pebble.Schema
  alias Pebble.Site
  alias Pebble.Changeset

  import Ecto.Changeset

  typed_schema "fragments" do
    field :data, :string

    belongs_to :schema, Schema
    many_to_many :sites, Site, join_through: "fragments_sites"

    timestamps()
  end

  def changeset_for(%Changeset{} = changeset, params \\ %{}) do
    %__MODULE__{schema: changeset.schema, sites: [changeset.site]}
    |> changeset(%{"data" => JSON.encode!(params)})
  end

  def changeset(fragment \\ %__MODULE__{}, params \\ %{}) do
    fragment
    |> cast(params, [:data])
    |> validate_required([:data])
  end
end
