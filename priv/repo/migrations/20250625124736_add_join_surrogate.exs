defmodule Pebble.Repo.Migrations.AddJoinSurrogate do
  use Ecto.Migration

  def change do
    alter table(:templates_sites) do
      add :id, :bigserial, primary_key: true
    end
  end
end
