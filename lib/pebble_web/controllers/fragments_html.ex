defmodule PebbleWeb.FragmentsHTML do
  @moduledoc false
  use PebbleWeb, :html

  embed_templates "fragments_html/*"

  defp get_visible_fields(schema, types) do
    schema.fields
    |> Enum.filter(fn {_, f} -> f[:visibility] in types end)
    |> Enum.map(fn {name, _} -> name end)
  end

  defp get_main_field(schema) do
    schema
    |> get_visible_fields(["main"])
    |> List.first()
  end

  defp field_label(schema, name) when is_atom(name) do
    data = schema.fields[name]
    data["label"] || labelify(name)
  end

  defp labelify(name) do
    name |> to_string() |> String.capitalize()
  end

  defp field_value(fragment, name) do
    stringify(fragment.values[to_string(name)])
  end

  defp stringify(nil), do: ""
  defp stringify(value) when is_binary(value), do: value
  defp stringify(value), do: to_string(value)
end