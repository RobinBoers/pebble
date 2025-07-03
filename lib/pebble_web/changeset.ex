defmodule Pebble.Changeset do
  @moduledoc false
  use TypedStruct

  alias Pebble.Fragment
  alias Pebble.Schema
  alias Pebble.Site

  typedstruct do
    field :data, %{}
    field :schema, Schema.t()
    field :params, map()
    field :site, Site.t()
  end

  @spec new(Schema.t(), Site.t(), %{String.t() => term()}) :: t()
  @spec new(Fragment.t(), Site.t(), %{String.t() => term()}) :: t()

  def new(schema_or_fragment, site, params \\ %{})

  def new(%Schema{} = schema, site, params) do
    %__MODULE__{
      data: %{},
      schema: schema,
      params: params,
      site: site
    }
  end

  def new(%Fragment{} = fragment, site, params) do
    %__MODULE__{
      data: JSON.decode!(fragment.data),
      schema: fragment.schema,
      params: params,
      site: site
    }
  end
end

defimpl Phoenix.HTML.FormData, for: Pebble.Changeset do
  @moduledoc false

  alias Phoenix.HTML.Form
  alias Pebble.Schema
  alias Pebble.Changeset

  import Pebble.Map, only: [naive_get: 2]

  @spec to_form(Changeset.t(), Keyword.t()) :: Form.t()
  def to_form(%Changeset{} = changeset, opts) do
    {name, opts} = Keyword.pop(opts, :as, "fragment")
    {errors, opts} = Keyword.pop(opts, :errors, [])
    {action, opts} = Keyword.pop(opts, :action)

    id = Keyword.get(opts, :id) || name

    %Form{
      source: changeset,
      impl: __MODULE__,
      id: id,
      name: name,
      params: changeset.params,
      data: changeset.data,
      errors: errors,
      action: action,
      options: opts
    }
  end

  @spec to_form(Changeset.t(), Form.t(), Form.field(), Keyword.t()) :: [Form.t()]
  def to_form(_changeset, _parent_form, _field, _opts), do: []

  @spec input_type(Changeset.t(), Form.t(), Form.field()) :: atom()
  def input_type(%Changeset{} = changeset, _form, name) do
    case naive_get(changeset.schema.fields, name) do
      %{type: "boolean"} -> "checkbox"
      %{type: "datetime"} -> "datetime-local"
      %{type: "asset"} -> "text"
      %{type: "template"} -> "textarea"
      %{type: type} -> type
      _ -> "text"
    end
  end

  @spec input_validations(Changeset.t(), Form.t(), Form.field()) :: Keyword.t()
  def input_validations(%Changeset{} = changeset, _form, name) do
    if field = naive_get(changeset.schema.fields, name) do
      []
      |> maybe_required(field)
      |> maybe_min(field)
      |> maybe_max(field)
    end
  end

  defp maybe_required(opts, %{required: true}) do
    Keyword.put(opts, :required, true)
  end

  defp maybe_required(opts, _), do: opts

  defp maybe_min(opts, %{min: v}) when is_number(v) do
    Keyword.put(opts, :min, v)
  end

  defp maybe_min(opts, _), do: opts

  defp maybe_max(opts, %{max: v}) when is_number(v) do
    Keyword.put(opts, :max, v)
  end

  defp maybe_max(opts, _), do: opts

  @spec input_value(Changeset.t(), Form.t(), Form.field()) :: term()
  def input_value(%Changeset{} = changeset, _form, name) do
    %{schema: schema, data: data, params: params} = changeset
    naive_get(params, name) || naive_get(data, name) || find_default(schema, name)
  end

  defp find_default(%Schema{} = schema, name) do
    schema.fields |> naive_get(name) |> Map.get(:default)
  end
end