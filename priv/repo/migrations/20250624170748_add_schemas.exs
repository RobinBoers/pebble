defmodule Pebble.Repo.Migrations.AddSchemas do
  use Ecto.Migration

  def change do
    create table(:schemas, primary_key: false) do
      add :id, :string, primary_key: true
      add :label,      :text
      add :listing,    :text
      add :definition, :text

      timestamps()
    end

    create table(:schemas_sites, primary_key: false) do
      add :site_id,
          references(:sites, type: :string, on_delete: :delete_all),
          null: false

      add :schema_id,
          references(:schemas, type: :string, on_delete: :delete_all),
          null: false
    end

    create unique_index(:schemas_sites, [:site_id, :schema_id])
  end
end
