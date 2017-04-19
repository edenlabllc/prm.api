defmodule PRM.Repo.Migrations.CreatePRM.Employees.Employee do
  use Ecto.Migration

  def change do
    create table(:employees_employees) do
      add :position, :string, null: false
      add :status, :string, null: false
      add :employee_type, :string, null: false
      add :is_active, :boolean, default: false, null: false
      add :created_by, :uuid, null: false
      add :updated_by, :uuid, null: false
      add :start_date, :naive_datetime, null: false
      add :end_date, :naive_datetime
      add :legal_entity_id, references(:legal_entities, on_delete: :nothing)
      add :division_id, references(:divisions, on_delete: :nothing)
      add :party_id, references(:parties, on_delete: :nothing)

      timestamps()
    end

    create index(:employees_employees, [:legal_entity_id])
    create index(:employees_employees, [:division_id])
    create index(:employees_employees, [:party_id])
  end
end
