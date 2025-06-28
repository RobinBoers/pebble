defmodule Ecto.HumID do
  @moduledoc """
  Autogenerates 5-character human-readable binary IDs.
  """

  @length 5
  @base 36

  def generate_id do
    :crypto.strong_rand_bytes(4)
    |> :binary.decode_unsigned()
    |> Integer.to_string(@base)
    |> String.upcase()
    |> String.pad_leading(@length, "0")
    |> String.slice(-@length, @length)
  end
end
