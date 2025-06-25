defmodule Pebble.Contact do
  @moduledoc false
  use Ecto.TypedSchema

  typed_schema "contacts" do
    field :handle, :string
    field :url, :string
    field :email, :string
    field :notify, :boolean

    timestamps()
  end
end
