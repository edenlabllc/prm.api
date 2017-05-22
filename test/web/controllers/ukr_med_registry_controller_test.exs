defmodule PRM.Web.UkrMedControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias PRM.Registries.UkrMedRegistry

  @create_attrs %{
    edrpou: "14562399",
    name: "some name",
    inserted_by: "7488a646-e31f-11e4-aace-600308960662",
    updated_by: "7488a646-e31f-11e4-aace-600308960662"
  }

  @update_attrs %{
    edrpou: "04562300",
    name: "some updated name",
    inserted_by: "7488a646-e31f-11e4-aace-600308960668",
    updated_by: "7488a646-e31f-11e4-aace-600308960668"
  }

  @invalid_attrs %{
    inserted_by: nil,
    edrpou: nil,
    name: nil,
    updated_by: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    ukr_med_registry()
    ukr_med_registry()
    ukr_med_registry()
    ukr_med_registry()

    conn = get conn, ukr_med_registry_path(conn, :index, ["limit": 2])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 2 == length(resp["data"])
    assert resp["paging"]["has_more"]
  end

  test "search ukr_med_registries by edrpou", %{conn: conn} do
    %UkrMedRegistry{id: id_1, edrpou: edrpou_1} = ukr_med_registry()
    %UkrMedRegistry{id: id_2, edrpou: edrpou_2} = ukr_med_registry()

    conn = get conn, ukr_med_registry_path(conn, :index, [edrpou: edrpou_1])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert id_1 == resp |> List.first() |> Map.fetch!("id")

    conn = get conn, ukr_med_registry_path(conn, :index, [edrpou: edrpou_2])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert id_2 == resp |> List.first() |> Map.fetch!("id")

    conn = get conn, ukr_med_registry_path(conn, :index, [edrpou: "00000000"])
    assert json_response(conn, 200)["data"] == []
  end

  test "creates ukr_med_registry and renders ukr_med_registry when data is valid", %{conn: conn} do
    conn = post conn, ukr_med_registry_path(conn, :create), @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, ukr_med_registry_path(conn, :show, id)
    resp = json_response(conn, 200)["data"]

    assert Map.has_key?(resp, "inserted_at")
    assert Map.has_key?(resp, "updated_at")
    assert Map.drop(resp, ["inserted_at", "updated_at"]) == %{
      "id" => id,
      "edrpou" => "14562399",
      "name" => "some name",
      "inserted_by" => "7488a646-e31f-11e4-aace-600308960662",
      "updated_by" => "7488a646-e31f-11e4-aace-600308960662"
    }
  end

  test "does not create ukr_med_registry and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, ukr_med_registry_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create ukr_med_registry and renders errors when edrpou is invalid", %{conn: conn} do
    conn = post conn, ukr_med_registry_path(conn, :create), Map.put(@create_attrs, "edrpou", "1234567")
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen ukr_med_registry and renders ukr_med_registry when data is valid", %{conn: conn} do
    %UkrMedRegistry{id: id} = ukr_med_registry = fixture(:ukr_med_registry)
    conn = put conn, ukr_med_registry_path(conn, :update, ukr_med_registry), @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, ukr_med_registry_path(conn, :show, id)
    resp = json_response(conn, 200)["data"]

    assert Map.has_key?(resp, "inserted_at")
    assert Map.has_key?(resp, "updated_at")
    assert Map.drop(resp, ["inserted_at", "updated_at"]) == %{
      "id" => id,
      "inserted_by" => "7488a646-e31f-11e4-aace-600308960668",
      "edrpou" => "04562300",
      "name" => "some updated name",
      "updated_by" => "7488a646-e31f-11e4-aace-600308960668"}
  end

  test "does not update chosen ukr_med_registry and renders errors when data is invalid", %{conn: conn} do
    ukr_med_registry = fixture(:ukr_med_registry)
    conn = put conn, ukr_med_registry_path(conn, :update, ukr_med_registry), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
