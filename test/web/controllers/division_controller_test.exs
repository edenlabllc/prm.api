defmodule PRM.Web.DivisionControllerTest do
  use PRM.Web.ConnCase

  alias PRM.Entities
  alias PRM.Entities.Division

  @create_attrs %{address: %{}, email: "some email", external_id: "some external_id", mountain_group: "some mountain_group", name: "some name", phones: %{}, type: "some type"}
  @update_attrs %{address: %{}, email: "some updated email", external_id: "some updated external_id", mountain_group: "some updated mountain_group", name: "some updated name", phones: %{}, type: "some updated type"}
  @invalid_attrs %{address: nil, email: nil, external_id: nil, mountain_group: nil, name: nil, phones: nil, type: nil}

  def fixture(:division) do
    {:ok, division} = Entities.create_division(@create_attrs)
    division
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, division_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates division and renders division when data is valid", %{conn: conn} do
    conn = post conn, division_path(conn, :create), division: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, division_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "address" => %{},
      "email" => "some email",
      "external_id" => "some external_id",
      "mountain_group" => "some mountain_group",
      "name" => "some name",
      "phones" => %{},
      "type" => "some type"}
  end

  test "does not create division and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, division_path(conn, :create), division: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen division and renders division when data is valid", %{conn: conn} do
    %Division{id: id} = division = fixture(:division)
    conn = put conn, division_path(conn, :update, division), division: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, division_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "address" => %{},
      "email" => "some updated email",
      "external_id" => "some updated external_id",
      "mountain_group" => "some updated mountain_group",
      "name" => "some updated name",
      "phones" => %{},
      "type" => "some updated type"}
  end

  test "does not update chosen division and renders errors when data is invalid", %{conn: conn} do
    division = fixture(:division)
    conn = put conn, division_path(conn, :update, division), division: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen division", %{conn: conn} do
    division = fixture(:division)
    conn = delete conn, division_path(conn, :delete, division)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, division_path(conn, :show, division)
    end
  end
end
