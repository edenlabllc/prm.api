defmodule PRM.Web.DivisionControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias PRM.Entities.Division

  @update_attrs %{
    address: %{},
    email: "some updated email",
    external_id: "some updated external_id",
    mountain_group: "some updated mountain_group",
    name: "some updated name",
    phones: %{},
    type: "ambulant_clinic"
  }

  @invalid_attrs %{
    address: nil,
    email: nil,
    external_id: nil,
    mountain_group: nil,
    name: nil,
    phones: nil,
    type: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, division_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates division and renders division when data is valid", %{conn: conn} do
    %{id: legal_entity_id} = fixture(:legal_entity)

    attr = %{
      address: %{},
      email: "some email",
      external_id: "some external_id",
      name: "some name",
      phones: %{},
      type: "fap",
      legal_entity_id: legal_entity_id
    }

    conn = post conn, division_path(conn, :create), attr
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, division_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "address" => %{},
      "email" => "some email",
      "external_id" => "some external_id",
      "mountain_group" => nil,
      "name" => "some name",
      "phones" => %{},
      "type" => "fap",
      "legal_entity_id" => legal_entity_id
    }
  end

  test "does not create division and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, division_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen division and renders division when data is valid", %{conn: conn} do
    %Division{id: id, legal_entity_id: legal_entity_id} = division = fixture(:division)
    conn = put conn, division_path(conn, :update, division), @update_attrs
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
      "type" => "ambulant_clinic",
      "legal_entity_id" => legal_entity_id
    }
  end

  test "does not update chosen division and renders errors when data is invalid", %{conn: conn} do
    division = fixture(:division)
    conn = put conn, division_path(conn, :update, division), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
