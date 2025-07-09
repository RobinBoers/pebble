defmodule PebbleWeb.IdentityHTML do
  @moduledoc false
  use PebbleWeb, :html

  embed_templates "identity_html/*"

  defp labelify(name) do
    name |> to_string() |> String.capitalize()
  end
end