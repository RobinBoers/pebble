defmodule Ecto.TypedSchema do
  @moduledoc """
  Provides a very thin wrapped around the `TypedEctoSchema` library
  with sane-defaults. Additionally, it configures the use of
  `Ecto.HumID` as default primary key.
  """

  defmacro __using__(_) do
    quote do
      use TypedEctoSchema

      @primary_key {:id, :string, autogenerate: {Ecto.HumID, :generate_id, []}}
      @foreign_key_type :string
    end
  end
end
