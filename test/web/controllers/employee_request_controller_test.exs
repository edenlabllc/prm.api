defmodule PRM.Web.EmployeeRequestControllerTest do
  @moduledoc false

  use PRM.Web.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates employee request and renders employee request when data is valid", %{conn: conn} do
    conn = post conn, employee_request_path(conn, :create), %{}
    assert %{"data" => %{}} = json_response(conn, 201)["data"]
  end
end
