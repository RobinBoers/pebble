defmodule Pebble.Layout do
  @moduledoc """
  A layout is a template that can embed other templates that is
  usually used for shared site code, like the header, menu and footer.
  """
  use Ecto.TypedSchema

  alias Pebble.Site

  import Ecto.Changeset

  # TODO(robin): prevent self- and circular extends.

  typed_schema "layouts" do
    field :label, :string
    field :content, :string

    # has_one :extends, __MODULE__, foreign_key: :extends_id
    # ^^ better?
    belongs_to :extends, __MODULE__, foreign_key: :extends_id
    belongs_to :site, Site

    timestamps()
  end

  def changeset_for(%Site{} = site, params \\ %{}) do
    changeset(%__MODULE__{site: site}, params)
  end

  def changeset(schema \\ %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:label, :content, :extends_id])
    |> cast_assoc(:site, required: true)
    |> validate_required([:label])
  end
end
