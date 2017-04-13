defmodule PRM.Repo.Migrations.EntitiesRelations do
  use Ecto.Migration

  def change do
    alter table(:divisions) do
      add :legal_entity_id, references(:legal_entities, on_delete: :nothing)
    end

    alter table(:medical_service_providers) do
      add :legal_entity_id, references(:legal_entities, on_delete: :nothing)
    end

    alter table(:legal_entities) do
      add :msp_id, references(:medical_service_providers, on_delete: :nothing)
      add :capitation_contract_id, references(:medical_service_providers, on_delete: :nothing)
    end

    create index(:divisions, [:legal_entity_id])
    create index(:medical_service_providers, [:legal_entity_id])
    create index(:legal_entities, [:msp_id])
    create index(:legal_entities, [:capitation_contract_id])
  end
end
