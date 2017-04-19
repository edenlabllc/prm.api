defmodule PRM.Employees.EmployeeDoctor do
  use Ecto.Schema

  schema "employees_employee_doctors" do
    field :education, :map
    field :qualification, :map
    field :science_degree, :map
    field :specialities, :map

    belongs_to :employee, PRM.Employees.Employee, type: Ecto.UUID

    timestamps()
  end
end
