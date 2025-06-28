defmodule Pebble.Repo.Migrations.AddTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :string, primary_key: true
      add :label,      :text
      add :content,    :text
      add :type,       :text
      add :visibility, :text

      timestamps()
    end

    create table(:templates_sites, primary_key: false) do
      # This join table has a primary key because Ecto is annoying.
      add :id, :string, primary_key: true

      add :route, :text

      add :layout_id,
          references(:layouts, type: :string, on_delete: :nilify_all)

      add :site_id,
          references(:sites, type: :string, on_delete: :delete_all),
          null: false

      add :template_id,
          references(:templates, type: :string, on_delete: :delete_all),
          null: false
    end

    create unique_index(:templates_sites, [:site_id, :route])
    create unique_index(:templates_sites, [:site_id, :template_id])
  end
end
