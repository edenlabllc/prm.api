defmodule PRM.Employees do
  @moduledoc """
  The boundary for the Employees system.
  """
  use PRM.Search

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Employees.Employee
  alias PRM.Employees.EmployeeSearch
  alias Ecto.Paging

  @fields_employee ~W(
    party_id
    legal_entity_id
    division_id
    position
    status
    employee_type
    is_active
    inserted_by
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
    inserted_by
    updated_by
    start_date
  )a

  @employee_types ~W(
    doctor
    hr
    admin
    owner
    accountant
  )

  def list_employees(params) do
    %EmployeeSearch{}
    |> employee_changeset(params)
    |> search(params, Employee, Confex.get(:prm, :employees_per_page))
    |> preload_doctor()
  end

  def preload_doctor({employees, %Ecto.Paging{} = paging}) when length(employees) > 0 do
    {Repo.preload(employees, :doctor), paging}
  end
  def preload_doctor({:ok, employees}) do
    {:ok, Repo.preload(employees, :doctor)}
  end
  def preload_doctor(err), do: err

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

  defp employee_changeset(%EmployeeSearch{} = employee, attrs) do
    fields =  ~W(
      party_id
      msp_id
      division_id
      status
      employee_type
    )

    statuses = ~W(
      ACTIVE
      INACTIVE
    )

    employee
    |> cast(attrs, fields)
    |> validate_inclusion(:employee_type, @employee_types)
    |> validate_inclusion(:status, statuses)
  end

  defp employee_changeset(%Employee{} = employee, attrs) do
    employee
    |> cast(attrs, @fields_employee)
    |> cast_assoc(:doctor)
    |> validate_required(@fields_required_employee)
    |> validate_inclusion(:employee_type, @employee_types)
    |> validate_employee_type()
  end

  defp validate_employee_type(%Ecto.Changeset{changes: %{employee_type: "doctor"}} = changeset) do
    validate_required(changeset, [:doctor])
  end
  defp validate_employee_type(changeset), do: changeset
end
