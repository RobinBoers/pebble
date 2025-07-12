defmodule Pebble do
  @moduledoc """
  Pebble is the best CMS in the multiverse.
  """

  alias Pebble.Repo
  alias Pebble.Site
  alias Pebble.Schema
  alias Pebble.Fragment
  alias Pebble.Layout
  alias Pebble.Template
  alias Pebble.Context
  alias Pebble.Contact
  alias Pebble.Settings

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
  @spec fetch_schemas(Site.t()) :: [Schema.t()]

  def fetch_schemas(%Site{id: site_id}) do
    fetch_schemas(site_id)
  end

  def fetch_schemas(site_id) do
    site_id
    |> schema_query()
    |> Repo.all()
  end

  @doc """
  Gets a `Pebble.Layout` for the given `Pebble.Site`.
  """
  @spec get_schema(integer(), Site.t()) :: Schema.t() | nil
  @spec get_schema(integer(), integer()) :: Schema.t() | nil

  def get_schema(id, %Site{id: site_id}) do
    get_schema(id, site_id)
  end

  def get_schema(id, site_id) do
    site_id
    |> schema_query()
    |> where([s], s.id == ^id)
    |> Repo.one()
    |> maybe_populate_schema()
  end

  defp schema_query(site_id) do
    from sc in Schema,
      join: s in assoc(sc, :sites),
      where: s.id == ^site_id,
      preload: :sites,
      order_by: [desc: sc.updated_at]
  end

  defp sorted_fields(definition) do
    fields = decode_toml(definition)
    order = field_order(definition)

    for name <- order do
      {name, Map.get(fields, name)}
    end
  end

  defp decode_toml(nil), do: []
  defp decode_toml(definition) do
    Toml.decode!(definition, keys: :atoms)
  end

  def field_order(nil), do: []
  def field_order(definition) do
    definition
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&table_header?/1)
    |> Enum.map(&extract_name/1)
  end

  defp table_header?(line) do
    String.starts_with?(line, "[") and String.ends_with?(line, "]")
  end

  defp extract_name(line) do
    line
    |> String.trim_leading("[")
    |> String.trim_trailing("]")
    |> String.to_atom()
  end

  @doc """
  Lists all fragments with the given `Pebble.Schema` for the given `Pebble.Site`.
  """
  @spec fetch_fragments(Schema.t(), Site.t()) :: [Layout.t()]
  @spec fetch_fragments(integer(), Site.t()) :: [Layout.t()]
  @spec fetch_fragments(Schema.t(), integer()) :: [Layout.t()]
  @spec fetch_fragments(integer(), integer()) :: [Layout.t()]

  def fetch_fragments(%Schema{id: schema_id}, %Site{id: site_id}) do
    fetch_fragments(schema_id, site_id)
  end

  def fetch_fragments(schema_id, %Site{id: site_id}) do
    fetch_fragments(schema_id, site_id)
  end

  def fetch_fragments(%Schema{id: schema_id}, site_id) do
    fetch_fragments(schema_id, site_id)
  end

  def fetch_fragments(schema_id, site_id) do
    schema_id
    |> fragment_query(site_id)
    |> Repo.all()
    |> Repo.preload([:schema])
    |> maybe_populate_values()
    |> maybe_populate_schemas()
  end

  defp fragment_query(schema_id, site_id) do
    from f in Fragment,
      join: s in assoc(f, :sites),
      where: f.schema_id == ^schema_id and s.id == ^site_id,
      order_by: [desc: f.updated_at]
  end

  defp maybe_populate_values(nil), do: nil

  defp maybe_populate_values(%Fragment{} = f) do
    Map.put(f, :values, JSON.decode!(f.data))
  end

  defp maybe_populate_values(fragments) when is_list(fragments) do
    Enum.map(fragments, &maybe_populate_values/1)
  end

  defp maybe_populate_schemas(fragments) when is_list(fragments) do
    Enum.map(fragments, &maybe_populate_schema/1)
  end

  @doc """
  Gets a `Pebble.Fragment` for the given `Pebble.Site`.
  """
  @spec get_fragment(integer(), Schema.t(), Site.t()) :: Fragment.t() | nil
  @spec get_fragment(integer(), integer(), Site.t()) :: Fragment.t() | nil
  @spec get_fragment(integer(), Schema.t(), integer()) :: Fragment.t() | nil
  @spec get_fragment(integer(), integer(), integer()) :: Fragment.t() | nil

  def get_fragment(id, %Schema{id: schema_id}, %Site{id: site_id}) do
    get_fragment(id, schema_id, site_id)
  end

  def get_fragment(id, schema_id, %Site{id: site_id}) do
    get_fragment(id, schema_id, site_id)
  end

  def get_fragment(id, %Schema{id: schema_id}, site_id) do
    get_fragment(id, schema_id, site_id)
  end

  def get_fragment(id, schema_id, site_id) do
    schema_id
    |> fragment_query(site_id)
    |> where([f], f.id == ^id)
    |> Repo.one()
    |> Repo.preload([:schema])
    |> maybe_populate_values()
    |> maybe_populate_schema()
  end

  defp maybe_populate_schema(nil), do: nil

  defp maybe_populate_schema(%Fragment{} = f) do
    Map.put(f, :schema, maybe_populate_schema(f.schema))
  end
  defp maybe_populate_schema(%Schema{} = s) do
    Map.put(s, :fields, sorted_fields(s.definition))
  end

  defp maybe_populate_settings(nil), do: nil
  defp maybe_populate_settings(%Settings{} = s) do
    Map.put(s, :fields, sorted_fields(s.definition))
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
      %Context{} = ctx ->
        Map.merge(template, Map.take(ctx, [:route, :layout]))

      nil ->
        template
    end
  end

  @doc """
  Gets the `Pebble.Settings` for the given `Pebble.Site`.
  """
  @spec get_settings(Site.t()) :: Settings.t() | nil
  @spec get_settings(integer()) :: Settings.t() | nil

  def get_settings(%Site{id: site_id}) do
    get_settings(site_id)
  end

  def get_settings(site_id) do
    Repo.one(from s in Settings,
      where: s.site_id == ^site_id,
      preload: :site)
    |> maybe_populate_settings()
  end

  @doc """
  Gets a `Pebble.Contact` by `id`.
  """
  @spec get_contact(integer()) :: Contact.t() | nil

  def get_contact(id) do
    Repo.get(Contact, id)
  end

  @doc """
  Lists all available contacts.
  """
  @spec fetch_contacts() :: [Contact.t()]

  def fetch_contacts do
    Repo.all(Contact)
  end

  @doc """
  Lists all menu categories for the given `Pebble.Site`.
  """
  @spec fetch_menu_categories(Site.t()) :: [Pebble.Menu.Category.t()]
  @spec fetch_menu_categories(integer()) :: [Pebble.Menu.Category.t()]

  def fetch_menu_categories(%Site{id: site_id}) do
    fetch_menu_categories(site_id)
  end

  def fetch_menu_categories(site_id) do
    site_id
    |> menu_category_query()
    |> order_by([c], c.inserted_at)
    |> Repo.all()
  end

  defp menu_category_query(site_id) do
    from c in Pebble.Menu.Category,
      join: cs in "categories_sites",
      on: c.id == cs.category_id,
      where: cs.site_id == ^site_id,
      order_by: [asc: c.order]
  end

  @doc """
  Gets a menu category for the given `Pebble.Site`.
  """
  @spec get_menu_category(integer(), Site.t()) :: Pebble.Menu.Category.t() | nil
  @spec get_menu_category(integer(), integer()) :: Pebble.Menu.Category.t() | nil

  def get_menu_category(id, %Site{id: site_id}) do
    get_menu_category(id, site_id)
  end

  def get_menu_category(id, site_id) do
    site_id
    |> menu_category_query()
    |> where([c], c.id == ^id)
    |> Repo.one()
  end

  @doc """
  Lists all menu items for the given `Pebble.Site`.
  """
  @spec fetch_menu_items(Site.t()) :: [Pebble.Menu.Item.t()]
  @spec fetch_menu_items(integer()) :: [Pebble.Menu.Item.t()]

  def fetch_menu_items(%Site{id: site_id}) do
    fetch_menu_items(site_id)
  end

  def fetch_menu_items(site_id) do
    site_id
    |> menu_item_query()
    |> order_by([i], [i.order, i.inserted_at])
    |> Repo.all()
  end

  defp menu_item_query(site_id) do
    from i in Pebble.Menu.Item,
      join: is in "items_sites",
      on: i.id == is.item_id,
      where: is.site_id == ^site_id,
      order_by: [asc: i.order],
      preload: [:category]
  end

  @doc """
  Gets a menu item for the given `Pebble.Site`.
  """
  @spec get_menu_item(integer(), Site.t()) :: Pebble.Menu.Item.t() | nil
  @spec get_menu_item(integer(), integer()) :: Pebble.Menu.Item.t() | nil

  def get_menu_item(id, %Site{id: site_id}) do
    get_menu_item(id, site_id)
  end

  def get_menu_item(id, site_id) do
    site_id
    |> menu_item_query()
    |> where([i], i.id == ^id)
    |> Repo.one()
  end
end
