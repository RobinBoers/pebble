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

      [index]
      type = boolean
      label = "Visible to search engines?"
      default = false

  """
  use Ecto.TypedSchema

  typed_schema "schemas" do
    field :label, :string
    field :definition, :string

    timestamps()
  end
end