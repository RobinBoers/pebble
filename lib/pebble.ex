defmodule Pebble do
  @moduledoc """
  Pebble is the best CMS in the multiverse.
  """

  alias Pebble.Repo
  alias Pebble.Site
  alias Pebble.Schema
  alias Pebble.Layout
  alias Pebble.Template
  alias Pebble.Context

  import Ecto.Query

  @doc """
  Lists all available sites.
  """
  @spec fetch_sites() :: [Site.t()]

  def fetch_sites do
    Repo.all(Site)
  end

  @doc """
  Lists all available schemas.
  """
  @spec fetch_schemas() :: [Schema.t()]

  def fetch_schemas do
    Repo.all(Schema)
  end

  @doc """
  Gets a `Pebble.Schema` by `id`.
  """
  @spec get_schema(integer()) :: Schema.t() | nil

  def get_schema(id) do
    with %Schema{} = s <- Repo.get(Schema, id) do
      Map.put(s, :fields, decode_toml(s.definition))
    end
  end

  defp decode_toml(nil), do: []
  defp decode_toml(definition) do
    Toml.decode!(definition, keys: :atoms)
  end

  @doc """
  Gets a `Pebble.Layout` for the given `Pebble.Site`.
  """
  @spec get_layout(integer(), Site.t()) :: Layout.t() | nil
  @spec get_layout(integer(), integer()) :: Layout.t() | nil

  def get_layout(id, %Site{id: site_id}) do
    get_layout(id, site_id)
  end

  def get_layout(id, site_id) do
    Repo.one(from l in Layout,
      where: l.id == ^id and l.site_id == ^site_id,
      preload: :site)
  end

  @doc """
  Lists all layouts for the given `Pebble.Site`.
  """
  @spec fetch_layouts(Site.t()) :: [Layout.t()]
  @spec fetch_layouts(integer()) :: [Layout.t()]

  def fetch_layouts(%Site{id: site_id}) do
    fetch_layouts(site_id)
  end

  def fetch_layouts(site_id) do
    Repo.all(from l in Layout,
      where: l.site_id == ^site_id,
      order_by: [desc: l.updated_at])
  end

  @doc """
  Gets a `Pebble.Template` for the given `Pebble.Site`.
  """
  @spec get_template(integer(), Site.t()) :: Template.t() | nil
  @spec get_template(integer(), integer()) :: Template.t() | nil

  def get_template(id, %Site{id: site_id}) do
    get_template(id, site_id)
  end

  def get_template(id, site_id) do
    site_id
    |> template_query()
    |> where([t], t.id == ^id)
    |> Repo.one()
    |> maybe_populate_template(site_id)
  end

  defp template_query(site_id) do
    from t in Template,
      join: s in assoc(t, :linked_sites),
      where: s.site_id == ^site_id,
      preload: [
        :sites,
        linked_sites: ^from(s in Context, preload: [:layout])
      ]
  end

  defp maybe_populate_template(nil, _), do: nil
  defp maybe_populate_template(template, site_id) do
    populate_template(template, site_id)
  end

  @doc """
  Lists all templates for the given `Pebble.Site`.
  """
  @spec fetch_templates(Site.t()) :: [Template.t()]
  @spec fetch_templates(integer()) :: [Template.t()]

  def fetch_templates(%Site{id: site_id}) do
    fetch_templates(site_id)
  end

  def fetch_templates(site_id) do
    site_id
    |> template_query()
    |> order_by([t], desc: t.updated_at)
    |> Repo.all()
    |> Enum.map(&populate_template(&1, site_id))
  end

  defp populate_template(template, site_id) do
    %Template{linked_sites: linked} = template

    case Enum.find(linked, &(&1.site_id == site_id)) do
      %Context{} = settings ->
        settings
        |> Map.take([:route, :layout])
        |> Map.merge(template)

      nil ->
        template
    end
  end
end
