defmodule PRM.Repo.Migrations.AddedToDivisionStatus do
  use Ecto.Migration

  def change do
    alter table(:divisions) do
      add :status, :string, null: false
    end
  end
end
