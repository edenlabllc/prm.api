defmodule PRM.Web.DivisionControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias PRM.Entities.Division

  @update_attrs %{
    addresses: [%{}],
    email: "some updated email",
    external_id: "some updated external_id",
    mountain_group: "some updated mountain_group",
    name: "some updated name",
    phones: [%{}],
    status: "INACTIVE",
    type: "ambulant_clinic",
    location: %{"longitude" => 50.45000, "latitude" => 30.52333}
  }

  @invalid_attrs %{
    addresses: nil,
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
    division()
    division()
    division()
    division()

    conn = get conn, division_path(conn, :index, ["limit": 2])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 2 == length(resp["data"])
    assert resp["paging"]["has_more"]
  end

  test "search divisions invalid legal_entity_id param", %{conn: conn} do
    conn = get conn, division_path(conn, :index, [legal_entity_id: "invalid"])
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "search divisions by legal_entity_id_1", %{conn: conn} do
    %Division{id: id_1, legal_entity_id: legal_entity_id_1} = division()
    %Division{id: id_2, legal_entity_id: legal_entity_id_2} = division()

    conn = get conn, division_path(conn, :index, [legal_entity_id: legal_entity_id_1])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert id_1 == resp |> List.first() |> Map.fetch!("id")

    conn = get conn, division_path(conn, :index, [legal_entity_id: legal_entity_id_2])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert id_2 == resp |> List.first() |> Map.fetch!("id")

    conn = get conn, division_path(conn, :index, [legal_entity_id: "2f095674-7634-4462-83f2-080fb67fac6b"])
    assert json_response(conn, 200)["data"] == []
  end

  test "search divisions by type", %{conn: conn} do
    %Division{id: id_1} = division("clinic")
    %Division{id: id_2} = division("fap")

    conn = get conn, division_path(conn, :index, [type: "clinic"])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert id_1 == resp |> List.first() |> Map.fetch!("id")

    conn = get conn, division_path(conn, :index, [type: "fap"])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert id_2 == resp |> List.first() |> Map.fetch!("id")

    conn = get conn, division_path(conn, :index, [type: "ambulant_clinic"])
    assert json_response(conn, 200)["data"] == []
  end

  test "creates division and renders division when data is valid", %{conn: conn} do
    %{id: legal_entity_id} = fixture(:legal_entity)

    attr = %{
      addresses: [%{}],
      email: "some email",
      external_id: "some external_id",
      name: "some name",
      phones: [%{}],
      type: "fap",
      status: "ACTIVE",
      legal_entity_id: legal_entity_id,
      location: %{"longitude" => 50.45000, "latitude" => 30.52333}
    }

    conn = post conn, division_path(conn, :create), attr
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, division_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "addresses" => [%{}],
      "email" => "some email",
      "external_id" => "some external_id",
      "mountain_group" => nil,
      "name" => "some name",
      "phones" => [%{}],
      "status" => "ACTIVE",
      "type" => "fap",
      "legal_entity_id" => legal_entity_id,
      "location" => %{
        "longitude" => 50.45000,
        "latitude" => 30.52333
      }
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
      "addresses" => [%{}],
      "email" => "some updated email",
      "external_id" => "some updated external_id",
      "mountain_group" => "some updated mountain_group",
      "name" => "some updated name",
      "phones" => [%{}],
      "type" => "ambulant_clinic",
      "status" => "INACTIVE",
      "legal_entity_id" => legal_entity_id,
      "location" => %{
        "longitude" => 50.45000,
        "latitude" => 30.52333
      }
    }
  end

  test "does not update chosen division and renders errors when data is invalid", %{conn: conn} do
    division = fixture(:division)
    conn = put conn, division_path(conn, :update, division), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
