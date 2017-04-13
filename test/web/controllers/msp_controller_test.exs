defmodule PRM.Web.MSPControllerTest do
  use PRM.Web.ConnCase

  alias PRM.Entities
  alias PRM.Entities.MSP

  @create_attrs %{accreditation: %{}, license: %{}}
  @update_attrs %{accreditation: %{}, license: %{}}
  @invalid_attrs %{accreditation: nil, license: nil}

  def fixture(:msp) do
    {:ok, msp} = Entities.create_msp(@create_attrs)
    msp
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, msp_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates msp and renders msp when data is valid", %{conn: conn} do
    conn = post conn, msp_path(conn, :create), msp: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, msp_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "accreditation" => %{},
      "license" => %{}}
  end

  test "does not create msp and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, msp_path(conn, :create), msp: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen msp and renders msp when data is valid", %{conn: conn} do
    %MSP{id: id} = msp = fixture(:msp)
    conn = put conn, msp_path(conn, :update, msp), msp: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, msp_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "accreditation" => %{},
      "license" => %{}}
  end

  test "does not update chosen msp and renders errors when data is invalid", %{conn: conn} do
    msp = fixture(:msp)
    conn = put conn, msp_path(conn, :update, msp), msp: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen msp", %{conn: conn} do
    msp = fixture(:msp)
    conn = delete conn, msp_path(conn, :delete, msp)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, msp_path(conn, :show, msp)
    end
  end
end
