defmodule PRM.Unit.EmployeeDoctorTest do
  @moduledoc false

  use PRM.DataCase

  alias PRM.Employees.EmployeeDoctor
  import PRM.SimpleFactory

  test "create employee doctor" do
    employee = employee("accountant")

    assert {:error, _} = %EmployeeDoctor{}
      |> EmployeeDoctor.changeset(%{
        employee_id: employee.id,
        educations: [%{test: 10}],
        qualifications: [],
        science_degree: %{}
      })
      |> Repo.insert

    assert {:error, _} = %EmployeeDoctor{}
      |> EmployeeDoctor.changeset(%{
        employee_id: employee.id,
        specialities: [%{test: 5}],
        qualifications: [],
        science_degree: %{}
      })
      |> Repo.insert

    assert {:ok, _doctor} = %EmployeeDoctor{}
      |> EmployeeDoctor.changeset(%{
        employee_id: employee.id,
        specialities: [%{test: 5}],
        educations: [%{test: 10}],
        qualifications: [],
        science_degree: %{}
      })
      |> Repo.insert
  end
end
