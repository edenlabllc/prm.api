defmodule PRM.Web.EmployeeRequestController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.EmployeeRequests
  alias PRM.EmployeeRequests.EmployeeRequest

  action_fallback PRM.Web.FallbackController

  def create(conn, params) do
    with {:ok, %EmployeeRequest{} = employee_request} <- EmployeeRequests.create_employee_request(params) do
      conn
      |> put_status(:created)
      |> render("show.json", employee_request: employee_request)
    end
  end
end
