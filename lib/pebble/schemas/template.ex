defmodule Pebble.Template do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias Pebble.Site

  schema "templates" do
    field :label, :string
    field :route, :string
    field :content, :string
    field :type, Ecto.Atom # :heex, :md, :plain

    many_to_many :sites, Site, join_through: "templates_sites"

    timestamps()
  end

  def changeset(template, params \\ %{}) do
    template
    |> cast(params, [:label, :route, :content, :type, :site_id])
    |> validate_required([:label, :route, :type, :site_id])
    |> unique_constraint(:route)
  end
end