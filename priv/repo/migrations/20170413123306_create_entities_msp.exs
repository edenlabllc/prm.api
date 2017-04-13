defmodule PRM.Repo.Migrations.CreatePRM.Entities.MSP do
  use Ecto.Migration

  def change do
    create table(:medical_service_providers) do
      add :accreditation, :map
      add :license, :map
      add :legal_entity_id, references(:legal_entities, on_delete: :nothing)

      timestamps()
    end

    create index(:medical_service_providers, [:legal_entity_id])
  end
end
