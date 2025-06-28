defmodule Pebble.Repo.Migrations.AddMenuCategory do
  use Ecto.Migration

  def change do
    create table(:menu_categories, primary_key: false) do
      add :id, :string, primary_key: true
      add :label, :text

      timestamps()
    end

    create table(:categories_sites, primary_key: false) do
      add :site_id,
          references(:sites, type: :string, on_delete: :delete_all),
          null: false

      add :category_id,
          references(:menu_categories, type: :string, on_delete: :delete_all),
          null: false
    end

    create unique_index(:categories_sites, [:site_id, :category_id])
  end
end
