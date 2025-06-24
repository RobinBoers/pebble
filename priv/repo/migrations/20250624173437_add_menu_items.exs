defmodule Pebble.Repo.Migrations.AddMenuItems do
  use Ecto.Migration

  def change do
    create table(:menu_items) do
      add :label, :string
      add :route, :string
      add :order, :integer

      add :category_id, references(:menu_categories, on_delete: :delete_all)

      timestamps()
    end

    create table(:items_sites, primary_key: false) do
      add :site_id,
          references(:sites, on_delete: :delete_all),
          null: false

      add :item_id,
          references(:menu_items, on_delete: :delete_all),
          null: false
    end

    create unique_index(:items_sites, [:site_id, :item_id])
  end
end
