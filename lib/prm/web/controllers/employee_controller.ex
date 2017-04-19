defmodule PRM.Web.EmployeeController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.Employees
  alias PRM.Employees.Employee

  action_fallback PRM.Web.FallbackController

  def index(conn, params) do
    with {employees, %Ecto.Paging{} = paging} <- Employees.list_employees(params) do
      render(conn, "index.json", employees: employees)
    end
  end

  def create(conn, employee_params) do
    with {:ok, %Employee{} = employee} <- Employees.create_employee(employee_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", employee_path(conn, :show, employee))
      |> render("show.json", employee: employee)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = Employees.get_employee!(id)
    render(conn, "show.json", employee: employee)
  end

  def update(conn, %{"id" => id} = employee_params) do
    employee = Employees.get_employee!(id)

    with {:ok, %Employee{} = employee} <- Employees.update_employee(employee, employee_params) do
      render(conn, "show.json", employee: employee)
    end
  end
end
