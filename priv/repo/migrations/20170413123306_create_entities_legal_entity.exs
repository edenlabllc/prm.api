defmodule PRM.Repo.Migrations.CreatePRM.Entities.LegalEntity do
  use Ecto.Migration

  def change do
    create table(:legal_entities) do
      add :name, :string
      add :short_name, :string
      add :public_name, :string
      add :status, :string
      add :type, :string
      add :owner_property_type, :string
      add :legal_form, :string
      add :edrpou, :integer
      add :kveds, :map
      add :addresses, :map
      add :phones, :map
      add :email, :string
      add :active, :boolean, default: false, null: false
      add :created_by, :string
      add :updated_by, :string
      add :msp_id, references(:medical_service_providers, on_delete: :nothing)
      add :capitation_contract_id, references(:medical_service_providers, on_delete: :nothing)

      timestamps()
    end

    create index(:legal_entities, [:msp_id])
    create index(:legal_entities, [:capitation_contract_id])
  end
end
