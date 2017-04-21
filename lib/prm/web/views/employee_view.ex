defmodule PRM.Web.EmployeeView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.EmployeeView

  def render("index.json", %{employees: employees}) do
    render_many(employees, EmployeeView, "employee.json")
  end

  def render("show.json", %{employee: employee}) do
    render_one(employee, EmployeeView, "employee.json")
  end

  def render("employee.json", %{employee: %{employee_type: "doctor", doctor: doctor} = employee}) do
    employee
    |> render_employee()
    |> Map.put(:doctor, doctor)
  end

  def render("employee.json", %{employee: employee}) do
   render_employee(employee)
  end

  def render_employee(employee) do
   %{
      id: employee.id,
      position: employee.position,
      status: employee.status,
      employee_type: employee.employee_type,
      is_active: employee.is_active,
      inserted_by: employee.inserted_by,
      updated_by: employee.updated_by,
      start_date: employee.start_date,
      end_date: employee.end_date
    }
  end
end
