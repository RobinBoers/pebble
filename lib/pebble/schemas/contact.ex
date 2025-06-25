defmodule Pebble.Contact do
  @moduledoc """
  A handle used for @mentions.

  A contact refers to another person and their personal
  website. It can be used to tag others in your templates,
  which will automatically link to their websites.

  Additionally, an email address can be configured. If configured,
  and the `notify` attribute is set to `true`, an email will
  be sent whenever you tag them.
  """
  use Ecto.TypedSchema

  typed_schema "contacts" do
    field :handle, :string
    field :url, :string
    field :email, :string
    field :notify, :boolean

    timestamps()
  end
end
