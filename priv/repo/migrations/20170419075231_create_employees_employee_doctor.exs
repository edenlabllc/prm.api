defmodule PRM.Repo.Migrations.CreatePRM.Employees.EmployeeDoctor do
  use Ecto.Migration

  def change do
    create table(:employees_employee_doctors) do
      add :education, :map, null: false
      add :qualification, :map
      add :specialities, :map, null: false
      add :science_degree, :map
      add :employee_id, references(:employees, on_delete: :nothing)

      timestamps()
    end

    create index(:employees_employee_doctors, [:employee_id])
  end
end
