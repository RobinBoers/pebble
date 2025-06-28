defmodule Pebble.Repo.Migrations.AddFragments do
  use Ecto.Migration

  def change do
    create table(:fragments, primary_key: false) do
      add :id, :string, primary_key: true
      add :data, :text

      add :schema_id, references(:schemas, type: :string, on_delete: :delete_all), null: false

      timestamps()
    end

    create table(:fragments_sites, primary_key: false) do
      add :site_id,
          references(:sites, type: :string, on_delete: :delete_all),
          null: false

      add :fragment_id,
          references(:fragments, type: :string, on_delete: :delete_all),
          null: false
    end

    create unique_index(:fragments_sites, [:site_id, :fragment_id])
  end
end
