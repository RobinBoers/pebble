defmodule Ecto.TypedSchema do
  @moduledoc false

  # This module provides a very thin wrapped around the `TypedEctoSchema`
  # library in case we might want to extends the schemas further.

  defmacro __using__(_) do
    quote do
      use TypedEctoSchema

      @primary_key {:id, :string, autogenerate: {Ecto.HumID, :generate_id, []}}
      @foreign_key_type :string
    end
  end
end
