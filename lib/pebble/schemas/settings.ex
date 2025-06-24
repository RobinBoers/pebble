defmodule Pebble.Settings do
  @moduledoc false
  use Ecto.Schema

  alias Pebble.Site

  schema "settings" do
    field :data, :string
    field :defintions, :string
    belongs_to :site, Site

    timestamps()
  end
end