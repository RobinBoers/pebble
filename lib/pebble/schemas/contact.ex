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

  import Ecto.Changeset

  typed_schema "contacts" do
    field :handle, :string
    field :url, :string
    field :email, :string
    field :notify, :boolean

    timestamps()
  end

  def changeset(contact \\ %__MODULE__{}, params \\ %{}) do
    contact
    |> cast(params, [:handle, :url, :email, :notify])
    |> validate_required([:handle, :url, :email, :notify])
    |> validate_format(:email, ~r[@], message: "must contain @")
    |> validate_format(:url, ~r[://], message: "must contain ://")
    |> validate_format(:handle, ~r/^@?[A-Za-z0-9_]+$/, message: "must be alphanumeric")
    |> update_change(:handle, &strip_at/1)
  end

  defp strip_at(value) when is_binary(value) do
    String.replace_prefix(value, "@", "")
  end

  defp strip_at(value), do: value
end
