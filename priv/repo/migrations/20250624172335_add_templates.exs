defmodule Pebble.Repo.Migrations.AddTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :label,   :text
      add :content, :text
      add :type,    :text

      timestamps()
    end

    # This join table has a primary key because Ecto is annoying.
    create table(:templates_sites) do
      add :route, :text

      add :layout_id,
          references(:layouts, on_delete: :nilify_all)

      add :site_id,
          references(:sites, on_delete: :delete_all),
          null: false

      add :template_id,
          references(:templates, on_delete: :delete_all),
          null: false
    end

    create unique_index(:templates_sites, [:site_id, :route])
    create unique_index(:templates_sites, [:site_id, :template_id])
  end
end
