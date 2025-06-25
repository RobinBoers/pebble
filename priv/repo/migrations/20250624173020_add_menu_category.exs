defmodule Pebble.Repo.Migrations.AddMenuCategory do
  use Ecto.Migration

  def change do
    create table(:menu_categories) do
      add :label, :text

      timestamps()
    end

    create table(:categories_sites, primary_key: false) do
      add :site_id,
          references(:sites, on_delete: :delete_all),
          null: false

      add :category_id,
          references(:menu_categories, on_delete: :delete_all),
          null: false
    end

    create unique_index(:categories_sites, [:site_id, :category_id])
  end
end
