defmodule PRM.Web.PageControllerTest do
  use PRM.Web.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/api"
    assert Map.get(json_response(conn, 200), "data")
  end
end
