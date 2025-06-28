defmodule Pebble.Asset do
  @moduledoc """
  Represents an URL to an image or video.

  An asset can optionally be annotated with a filename
  (given during uploading) and alt text (for screenreaders).
  """
  use Ecto.TypedSchema

  typed_schema "assets" do
    field :url, :string
    field :alt, :string
    field :filename, :string

    timestamps()
  end
end
