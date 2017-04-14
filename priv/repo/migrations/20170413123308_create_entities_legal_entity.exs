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
      add :edrpou, :string
      add :kveds, :map
      add :addresses, :map
      add :phones, :map
      add :email, :string
      add :is_active, :boolean, default: false, null: false
      add :created_by, :string
      add :updated_by, :string

      timestamps()
    end
  end
end
