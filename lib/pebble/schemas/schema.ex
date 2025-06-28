defmodule Pebble.Schema do
  @moduledoc """
  TOML definitions for well-defined data.

  Schemas express the keys present in JSON data stored by
  both `Pebble.Fragment` and `Pebble.Settings` instances.

  Field definitions consist of a table for each field with
  at least the following keys:

  - `type`: the field type, see more below.

  Additionaly, the following options are supported too:

  - `label`: the label for the field in the editor.
  - `required`: whether the field is nullable or not.
  - `default`: prefilled value on creation.
  - `min`: a minimum amount of characters (for textual input)
     or a minimum for numerical input.
  - `max`: a maximum amount of characters (for textual input)
     or a maximum for numerical input.
  - `options`: a list of string options for a select.

  ## Listings

  For listings in the fragment editor, an additional property `visibility`
  can be declared.

  There are two views in the editor:

  - `table` view, most appropriate for schemas with a clear title/name field.
  - `inline` view, for schemas that contain one key of 'content', without
    a clear name. This content will be rendered inline, with some additional
    data rendered below.

  The `visibily` option can be one of the following, depending on the render type:
  
  - `column` to declare that the field is a column in `table` view.
  - `main` to declare the field is the primary content in `inline` view.
  - `meta` to declare the field is additional metadata in `inline` view.
  - `none` to declare the field should be omitted entirely from listings.

  If no fields have configured `visibility`, or all fields are hidden, the
  `Ecto.HumID` of the resource will be rendered instead.

  Furthermore, for display type `table`, visibilities `main` and `meta` will
  be interpreted as being `column`, and in reverse `column` will be interpreted
  as `meta` on `inline` views.

  ## Field types

  - `text`: a single line string.
  - `textarea`: a multiline string.
  - `number`: an integer or float value.
  - `boolean`: a checkbox (true or false).
  - `select`: a predefined option from a select dropdown.
  - `date`: a local date.
  - `time`: a local time.
  - `datetime`: a local datetime.
  - `color`: a hexidecimal color string.
  - `asset`: a reference to a `Pebble.Asset`.
  - `url`: an URL (parsed and validated to be well-formed).
  - `email`: an email address (validated to contain `@`).
  - `template`: a HEEx template (validated to be well-formed).

  ## Appendix 1: Example (`"article"`)

      [title]
      type = "text"
      required = true
      visibility = "column"

      [content]
      type = "prose"
      label = "Prose"
      visibility = "none"

      [index]
      type = "boolean"
      label = "Visible to search engines?"
      default = false
      visibility = "none"

      [visibility]
      type = "select"
      default = "draft"
      options = ["draft", "hidden", "rss", "public"]

  ## Appendix 2: Another example (`"tweet"`)

      [content]
      type = "textarea"
      label = "What's on your mind?"
      required = true
      visibility = "main"

      [photo]
      type = "asset"
      label = "Attach photo?"

      [thread]
      type = "text"
      label = "Thread"

  """
  use Ecto.TypedSchema

  import Ecto.Changeset

  @listings ~w(table inline)a
  @properties ~w(type label required default min max visibility options order)
  @types ~w(text textarea number boolean select date time datetime color asset url email template)

  @doc "Supported render types."
  def listings, do: @listings

  @doc "Supported field properties."
  def properties, do: @properties

  @doc "Supported field types."
  def field_types, do: @types

  typed_schema "schemas" do
    field :label, :string
    field :listing, Ecto.Atom, default: :table
    field :definition, :string

    # Contains the parsed TOML data if populated.
    field :fields, {:array, :map}, virtual: true

    timestamps()
  end

  def changeset(schema \\ %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:label, :listing, :definition])
    |> validate_required([:label])
    |> validate_schema(:definition)
  end

  defp validate_schema(changeset, field) when is_atom(field) do
    validate_schema(changeset, field, get_field(changeset, field))
  end

  defp validate_schema(changeset, _, d) when d in [nil, ""] do
    changeset
  end

  defp validate_schema(changeset, field, definition) do
    case Toml.decode(definition) do
      {:ok, data} ->
        data
        |> collect_errors()
        |> Enum.reduce(changeset, &add_error(&2, field, &1))
      
      _ ->
        add_error(changeset, field, "invalid toml")
    end
  end

  # TODO(robin): validate required field properties (rn only type).
  # also validate max and min only on textual and numerical inputs.
  # validate options only on select fields.

  @doc """
  Validates whether the given TOML definition is a valid `Pebble.Schema`.

  Returns either a single error or a list of errors.
  """
  @spec validate(String.t()) :: :ok | {:error, String.t() | [String.t()]}
  def validate(definition) when is_binary(definition) do
    case Toml.decode(definition) do
      {:ok, data} -> validate_data(data)
      _ -> {:error, "invalid toml"}
    end
  end

  defp validate_data(data) do
    case collect_errors(data) do
      [] -> :ok
      e -> {:error, e}
    end
  end

  defp collect_errors(data) do
    Enum.flat_map(data, fn {key, defn} ->
      key
      |> validate_field(defn)
      |> List.wrap()
      |> Enum.reject(&is_nil/1)
      |> List.flatten()
    end)
  end

  defp validate_field(key, defn) when not is_map(defn) do
    "top-level key '#{key}' not supported"
  end

  defp validate_field(key, defn) do
    for {prop, val} <- defn do
      validate_property(key, prop, val)
    end
  end

  defp validate_property(key, "type", val) do
    unless val in field_types() do
      "unsupported field type '#{val}' for field '#{key}'"
    end
  end

  defp validate_property(key, "label", val) do
    unless is_binary(val) do
      "unsupported label value for field '#{key}'"
    end
  end

  defp validate_property(key, "required", val) do
    unless val in [true, false] do
      "'required' property on field '#{key}' should be a boolean "
    end
  end

  defp validate_property(key, "min", val) do
    unless is_number(val) and val >= 0 do
      "unsupported min value for field '#{key}'"
    end
  end

  defp validate_property(key, "max", val) do
    unless is_number(val) and val >= 0 do
      "unsupported max value for field '#{key}'"
    end
  end

  defp validate_property(key, "visibility", val) do
    unless val in ~w(column main meta none) do
      "unsupported visibility '#{val}' for field '#{key}'"
    end
  end

  defp validate_property(_key, prop, _val) when prop in @properties, do: []

  defp validate_property(key, prop, _val) do
    "unknown property '#{prop}' on field '#{key}'"
  end
end
