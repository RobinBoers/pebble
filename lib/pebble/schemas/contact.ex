defmodule Pebble.Contact do
  @moduledoc false
  use Ecto.Schema

  schema "contacts" do
    field :handle, :string
    field :url, :string
    field :email, :string
    field :notify, :boolean

    timestamps()
  end
end
