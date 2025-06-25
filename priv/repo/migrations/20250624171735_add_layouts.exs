defmodule Pebble.Repo.Migrations.AddLayouts do
  use Ecto.Migration

  def change do
    create table(:layouts) do
      add :label,   :text
      add :content, :text
      add :extends, :text

      add :extends_id, references(:layouts, on_delete: :nilify_all)
      add :site_id, references(:sites, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:layouts, [:extends_id])
    create index(:layouts, [:site_id])
  end
end
