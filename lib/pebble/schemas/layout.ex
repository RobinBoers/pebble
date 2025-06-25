defmodule Pebble.Layout do
  @moduledoc false
  use Ecto.TypedSchema

  import Ecto.Changeset

  alias Pebble.Site

  typed_schema "layouts" do
    field :label, :string
    field :content, :string

    # has_one :extends, __MODULE__, foreign_key: :extends_id
    # ^^ better?
    belongs_to :extends, __MODULE__, foreign_key: :extends_id
    belongs_to :site, Site

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:label, :content, :extends_id])
    |> cast_assoc(:site, required: true)
    |> validate_required([:label])
  end
end
