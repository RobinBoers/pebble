defmodule PebbleWeb.TemplatesHTML do
  @moduledoc  false
  use PebbleWeb, :html

  embed_templates "templates_html/*"

  defp current_site?(form, site) do
    form[:site_id].value == site.id
  end
end
