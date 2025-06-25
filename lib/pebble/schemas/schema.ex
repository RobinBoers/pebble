defmodule Pebble.Schema do
  @moduledoc """
  TOML definitions for well-defined data.

  Schemas express the keys present in JSON data stored by
  both `Pebble.Fragment` and `Pebble.Settings` instances.

  Field definitions consist of a table for each field with
  at least the following keys:

  - `type`: the field type, see more below.
  - `label`: the label for the field in the editor.

  Additionaly, the following options are supported too:

  - `required`: whether the field is nullable or not.
  - `default`: prefilled value on creation.
  - `min`: a minimum amount of characters (for textual input)
     or a minimum for numerical input.
  - `max`: a maximum amount of characters (for textual input)
     or a maximum for numerical input.

  ## Field types

  - `text`: a single line string.
  - `textarea`: a multiline string.
  - `number`: an integer or float value.
  - `boolean`: a checkbox (true or false).
  - `date`: a local date.
  - `time`: a local time.
  - `datetime`: a local datetime.
  - `color`: a hexidecimal color string.
  - `asset`: a reference to a `Pebble.Asset`.
  - `url`: an URL (parsed and validated to be well-formed).
  - `email`: an email address (validated to contain `@`).
  - `heex`: a HEEx template (validated to be well-formed).

  ## Appendix 1: Example (`"post"`)

      [title]
      type = text
      label = "Title"
      required = true

      [published]
      type = datetime
      label = "Published on"
      required = true

      [content]
      type = textarea
      label = "Content"
      required = true

      [photo]
      type = asset
      label = "Attach a photo"

      [index]
      type = boolean
      label = "Visible to search engines?"
      default = false

  """
  use Ecto.TypedSchema

  import Ecto.Changeset

  @doc "Supported field properties"
  def properties, do: ~w(type label required default min max)

  @doc "Supported field types"
  def field_types, do: ~w(text textarea number boolean date time datetime color asset url email heex)

  typed_schema "schemas" do
    field :label, :string
    field :definition, :string

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:label, :definition])
    |> validate_required([:label])
    # |> validate_schema(:definition)
  end

  # defp validate_schema(changeset, field) do
  #   changeset
  #   |> get_field(field)
  #   |> validate()
  #   |> case do
  #     :ok ->
  #       changeset

  #     {:error, errors} ->
  #       Enum.reduce
  #   end
  # end

  def validate(definition) do
    with {:ok, data} <- Toml.decode(definition) do
      # TODO(robin): the error from toml should also be a list w one string then.
      errors = Enum.flat_map(data, fn {key, defn} ->
        key |> validate_field(defn) |> List.wrap()
      end)

      if errors == [], do: :ok, else: {:error, errors}
    end
  end

  defp validate_field(key, defn) when not is_map(defn) do
    "top-level key #{key} will be ignored"
  end

  defp validate_field(key, defn) do
    {known, unknown} = Map.split(defn, properties())

    unknown_keys =
      for {prop, _} <- unknown do
        "property #{prop} on field #{key} does not exist; typo?"
      end

    type_errors =
      for {prop, val} <- known do
        validate_property(key, prop, val)
      end

    unknown_keys ++ type_errors
  end

  defp validate_property(key, "type", val) do
    unless val in field_types() do
      "unsupported field type #{val} for field #{key}"
    end
  end

  defp validate_property(key, "label", val) do
    unless is_binary(val) do
      "unsupported label value for field #{key}"
    end
  end

  defp validate_property(key, "required", val) do
    unless val in [true, false] do
      "required property should be a boolean for field #{key}"
    end
  end

  defp validate_property(_key, "default", _val), do: []

  defp validate_property(key, "min", val) do
    unless is_number(val) do
      "unsupported min value for field #{key}"
    end
  end

  defp validate_property(key, "max", val) do
    unless is_number(val) do
      "unsupported max value for field #{key}"
    end
  end

  defp validate_property(key, prop, _val) do
    "unknown property #{prop} on field #{key}"
  end
end
