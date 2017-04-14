defmodule PRM.Repo.Migrations.CreatePRM.Entities.LegalEntity do
  use Ecto.Migration

  def change do
    create table(:legal_entities, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :short_name, :string
      add :public_name, :string
      add :status, :string
      add :type, :string
      add :owner_property_type, :string
      add :legal_form, :string
      add :edrpou, :string
      add :kveds, :map
      add :addresses, :map
      add :phones, :map
      add :email, :string
      add :is_active, :boolean, default: false, null: false
      add :created_by, :uuid
      add :updated_by, :uuid

      timestamps()
    end
  end
end
