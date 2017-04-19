defmodule PRM.Employees do
  @moduledoc """
  The boundary for the Employees system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Employees.Employee

  @fields_employee ~W(
    party_id
    legal_entity_id
    division_id
    position
    status
    employee_type
    is_active
    created_by
    updated_by
    start_date
    end_date
  )

  @fields_required_employee ~W(
    party_id
    legal_entity_id
    division_id
    position
    status
    employee_type
    is_active
    created_by
    updated_by
    start_date
  )a

  def list_employees do
    Repo.all(Employee)
  end

  def get_employee!(id) do
    Employee
    |> Repo.get!(id)
    |> preload_references()
  end

  def preload_references(%{employee_type: "doctor"} = employee) do
    Repo.preload(employee, :doctor)
  end
  def preload_references(employee), do: employee

  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> employee_changeset(attrs)
    |> Repo.insert()
  end

  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> employee_changeset(attrs)
    |> Repo.update()
  end

  def change_employee(%Employee{} = employee) do
    employee_changeset(employee, %{})
  end

  defp employee_changeset(%Employee{} = employee, attrs) do
    employee
    |> cast(attrs, @fields_employee)
    |> cast_assoc(:doctor)
    |> validate_required(@fields_required_employee)
    |> validate_inclusion(:employee_type, ["doctor", "hr", "admin", "owner", "accountant"])
    |> validate_employee_type()
  end

  defp validate_employee_type(%Ecto.Changeset{changes: %{employee_type: "doctor"}} = changeset) do
    validate_required(changeset, [:doctor])
  end
  defp validate_employee_type(changeset), do: changeset
end
