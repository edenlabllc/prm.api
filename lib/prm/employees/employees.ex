defmodule PRM.Employees do
  @moduledoc """
  The boundary for the Employees system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.Employees.Employee

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees()
      [%Employee{}, ...]

  """
  def list_employees do
    Repo.all(Employee)
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> employee_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> employee_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{source: %Employee{}}

  """
  def change_employee(%Employee{} = employee) do
    employee_changeset(employee, %{})
  end

  defp employee_changeset(%Employee{} = employee, attrs) do
    employee
    |> cast(attrs, [:position, :status, :employee_type, :is_active, :created_by, :updated_by, :start_date, :end_date])
    |> validate_required([:position, :status, :employee_type, :is_active, :created_by, :updated_by, :start_date, :end_date])
  end

  alias PRM.Employees.EmployeeDoctor

  @doc """
  Returns the list of employee_doctors.

  ## Examples

      iex> list_employee_doctors()
      [%EmployeeDoctor{}, ...]

  """
  def list_employee_doctors do
    Repo.all(EmployeeDoctor)
  end

  @doc """
  Gets a single employee_doctor.

  Raises `Ecto.NoResultsError` if the Employee doctor does not exist.

  ## Examples

      iex> get_employee_doctor!(123)
      %EmployeeDoctor{}

      iex> get_employee_doctor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee_doctor!(id), do: Repo.get!(EmployeeDoctor, id)

  @doc """
  Creates a employee_doctor.

  ## Examples

      iex> create_employee_doctor(%{field: value})
      {:ok, %EmployeeDoctor{}}

      iex> create_employee_doctor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee_doctor(attrs \\ %{}) do
    %EmployeeDoctor{}
    |> employee_doctor_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee_doctor.

  ## Examples

      iex> update_employee_doctor(employee_doctor, %{field: new_value})
      {:ok, %EmployeeDoctor{}}

      iex> update_employee_doctor(employee_doctor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee_doctor(%EmployeeDoctor{} = employee_doctor, attrs) do
    employee_doctor
    |> employee_doctor_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a EmployeeDoctor.

  ## Examples

      iex> delete_employee_doctor(employee_doctor)
      {:ok, %EmployeeDoctor{}}

      iex> delete_employee_doctor(employee_doctor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee_doctor(%EmployeeDoctor{} = employee_doctor) do
    Repo.delete(employee_doctor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee_doctor changes.

  ## Examples

      iex> change_employee_doctor(employee_doctor)
      %Ecto.Changeset{source: %EmployeeDoctor{}}

  """
  def change_employee_doctor(%EmployeeDoctor{} = employee_doctor) do
    employee_doctor_changeset(employee_doctor, %{})
  end

  defp employee_doctor_changeset(%EmployeeDoctor{} = employee_doctor, attrs) do
    employee_doctor
    |> cast(attrs, [:education, :qualification, :specialities, :science_degree])
    |> validate_required([:education, :qualification, :specialities, :science_degree])
  end
end
