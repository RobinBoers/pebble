defmodule Pebble.Repo.Migrations.AddMenuItems do
  use Ecto.Migration

  def change do
    create table(:menu_items, primary_key: false) do
      add :id, :string, primary_key: true
      add :label, :text
      add :route, :text
      add :order, :integer

      add :category_id, references(:menu_categories, type: :string, on_delete: :delete_all)

      timestamps()
    end

    create table(:items_sites, primary_key: false) do
      add :site_id,
          references(:sites, type: :string, on_delete: :delete_all),
          null: false

      add :item_id,
          references(:menu_items, type: :string, on_delete: :delete_all),
          null: false
    end

    create unique_index(:items_sites, [:site_id, :item_id])
  end
end
