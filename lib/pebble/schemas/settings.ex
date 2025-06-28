defmodule Pebble.Settings do
  @moduledoc """
  The settings are a object of globally available variables
  within all templating in a `Pebble.Site`, along with a schema
  well-defining it.
  """
  use Ecto.TypedSchema

  alias Pebble.Site

  typed_schema "settings" do
    field :data, :string
    field :defintion, :string
    belongs_to :site, Site

    timestamps()
  end
end
