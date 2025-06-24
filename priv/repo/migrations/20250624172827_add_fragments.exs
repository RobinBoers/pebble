defmodule Pebble.Repo.Migrations.AddFragments do
  use Ecto.Migration

  def change do
    create table(:fragments) do
      add :data, :string

      add :schema_id, references(:schemas, on_delete: :delete_all), null: false

      timestamps()
    end

    create table(:fragments_sites, primary_key: false) do
      add :site_id,
          references(:sites, on_delete: :delete_all),
          null: false

      add :fragment_id,
          references(:fragments, on_delete: :delete_all),
          null: false
    end

    create unique_index(:fragments_sites, [:site_id, :fragment_id])
  end
end
