defmodule Pebble.Map do
  @moduledoc """
  Extends `Map` from the Elixir standard library.
  """

  @type key :: Map.key()
  @type value :: Map.value()

  @doc """
  Gets the `value` for a specific `key` in `map`, but
  works regardless of string or atom keys.

  ### Examples

      iex> naive_get(%{:a => 1, "b" => 2}, :b)
      2
      iex> naive_get(%{:a => 1, "b" => 2}, "a")
      1

  Keep in mind this method functions non-deterministicly
  for maps with duplicate atom/string keys, due to Erlang's
  intenral implementation of hash maps:

      %{:a => 1, "a" => 2} # no clue what will happen here.

  """
  @spec naive_get(map(), key()) :: value()
  def naive_get(map, key) do
    map
    |> Map.new(fn {k, v} -> {to_string(k), v} end)
    |> Map.get(to_string(key))
  end
end