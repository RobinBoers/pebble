defmodule Pebble.Repo.Migrations.AddTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :label,   :string
      add :route,   :string
      add :content, :string
      add :type,    :string

      timestamps()
    end

    create table(:templates_sites, primary_key: false) do
      add :layout_id,
          references(:layouts, on_delete: :nilify_all)

      add :site_id,
          references(:sites, on_delete: :delete_all),
          null: false

      add :template_id,
          references(:templates, on_delete: :delete_all),
          null: false
    end

    create unique_index(:templates_sites, [:site_id, :template_id])
  end
end
