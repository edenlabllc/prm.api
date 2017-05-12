defmodule PRM.Web.GlobalParameterControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all parameters on index", %{conn: conn} do
    fixture(:global_parameter, "param1", "value1")
    fixture(:global_parameter, "param2", "value2")
    fixture(:global_parameter, "param3", "value3")

    conn = get conn, global_parameter_path(conn, :index)
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "data")
    assert Map.has_key?(resp["data"], "param1")
    assert "value1" == resp["data"]["param1"]
    assert Map.has_key?(resp["data"], "param2")
    assert "value2" == resp["data"]["param2"]
    assert Map.has_key?(resp["data"], "param3")
    assert "value3" == resp["data"]["param3"]
  end
end
