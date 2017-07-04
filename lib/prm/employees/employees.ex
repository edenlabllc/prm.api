defmodule PRM.Employees do
  @moduledoc """
  The boundary for the Employees system.
  """
  use PRM.Search

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Employees.Employee
  alias PRM.Employees.EmployeeSearch

  @fields_employee ~W(
    party_id
    legal_entity_id
    division_id
    position
    status
    status_reason
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
    position
    status
    employee_type
    is_active
    inserted_by
    updated_by
    start_date
  )a

  def list_employees(params) do
    %EmployeeSearch{}
    |> employee_changeset(params)
    |> search(params, Employee, Confex.get(:prm, :employees_per_page))
    |> preload_relations(params)
  end

  def get_search_query(Employee = entity, changes) do
    params =
      changes
      |> Map.drop([:tax_id, :edrpou])
      |> Map.to_list()

    entity
    |> query_tax_id(Map.get(changes, :tax_id))
    |> query_edrpou(Map.get(changes, :edrpou))
    |> where(^params)
  end

  def query_tax_id(query, nil), do: query

  def query_tax_id(query, tax_id) do
    query
    |> join(:left, [e], p in assoc(e, :party))
    |> where([e, p], p.tax_id == ^tax_id)
  end

  def query_edrpou(query, nil), do: query

  def query_edrpou(query, edrpou) do
    query
    |> join(:left, [e], le in assoc(e, :legal_entity))
    |> where([e, le], le.edrpou == ^edrpou)
  end

  def preload_relations({employees, %Ecto.Paging{} = paging}, params) when length(employees) > 0 do
    {preload_relations(employees, params), paging}
  end
  def preload_relations({:ok, employees}, params) do
    {:ok, preload_relations(employees, params)}
  end

  def preload_relations(repo, %{"expand" => _}) when length(repo) > 0 do
    repo
    |> Repo.preload(:doctor)
    |> Repo.preload(:party)
    |> Repo.preload(:division)
    |> Repo.preload(:legal_entity)
  end

  def preload_relations(err, _params), do: err

  def get_employee!(id) do
    Employee
    |> Repo.get!(id)
    |> preload_references()
  end

  def preload_references(%{employee_type: "DOCTOR"} = employee) do
    Repo.preload(employee, :doctor)
  end
  def preload_references(employee), do: employee

  def create_employee(attrs \\ %{}, user_id) do
    %Employee{}
    |> employee_changeset(attrs)
    |> Repo.insert_and_log(user_id)
  end

  def update_employee(%Employee{} = employee, attrs, user_id) do
    employee
    |> employee_changeset(attrs)
    |> Repo.update_and_log(user_id)
  end

  def change_employee(%Employee{} = employee) do
    employee_changeset(employee, %{})
  end

  defp employee_changeset(%EmployeeSearch{} = employee, attrs) do
    fields =  ~W(
      party_id
      legal_entity_id
      division_id
      status
      employee_type
      is_active
      tax_id
      edrpou
    )

    cast(employee, attrs, fields)
  end

  defp employee_changeset(%Employee{} = employee, attrs) do
    employee
    |> cast(attrs, @fields_employee)
    |> cast_assoc(:doctor)
    |> validate_required(@fields_required_employee)
    |> validate_employee_type()
    |> foreign_key_constraint(:legal_entity_id)
    |> foreign_key_constraint(:division_id)
    |> foreign_key_constraint(:party_id)
  end

  defp validate_employee_type(%Ecto.Changeset{changes: %{employee_type: "DOCTOR"}} = changeset) do
    validate_required(changeset, [:doctor])
  end
  defp validate_employee_type(changeset), do: changeset
end
