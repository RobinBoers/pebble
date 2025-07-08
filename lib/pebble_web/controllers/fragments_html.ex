defmodule PebbleWeb.FragmentsHTML do
  @moduledoc false
  use PebbleWeb, :html

  import Structo

  embed_templates "fragments_html/*"

  defp labelify(name) do
    name |> to_string() |> String.capitalize()
  end
end