defmodule Pebble.Settings do
  @moduledoc false
  use Ecto.TypedSchema

  alias Pebble.Site

  typed_schema "settings" do
    field :data, :string
    field :defintion, :string
    belongs_to :site, Site

    timestamps()
  end
end
