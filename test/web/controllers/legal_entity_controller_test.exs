defmodule PRM.Web.LegalEntityControllerTest do
  @moduledoc false

  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias PRM.Entities.LegalEntity

  @create_attrs %{
    is_active: true,
    addresses: [%{}],
    inserted_by: "026a8ea0-2114-11e7-8fae-685b35cd61c2",
    edrpou: "04512341",
    email: "some email",
    kveds: [],
    legal_form: "some legal_form",
    name: "some name",
    owner_property_type: "STATE",
    phones: [%{}],
    public_name: "some public_name",
    short_name: "some short_name",
    status: "VERIFIED",
    type: "MSP",
    updated_by: "1729f790-2114-11e7-97f0-685b35cd61c2",
    created_by_mis_client_id: "1729f790-2114-11e7-97f0-685b35cd61c2",
    medical_service_provider: %{
      licenses: [%{
        license_number: "fd123443"
      }],
      accreditation: %{
        category: "перша",
        order_no: "me789123"
      }
    }
  }

  @update_attrs %{
    is_active: false,
    nhs_verified: true,
    addresses: [%{}],
    inserted_by: "4756170a-2114-11e7-8e8a-685b35cd61c2",
    edrpou: "04512322",
    email: "some updated email",
    kveds: [],
    legal_form: "some updated legal_form",
    name: "some updated name",
    owner_property_type: "PRIVATE",
    phones: [%{}],
    public_name: "some updated public_name",
    short_name: "some updated short_name",
    status: "NOT_VERIFIED",
    type: "MIS",
    updated_by: "36cb4752-2114-11e7-96a7-685b35cd61c2",
    created_by_mis_client_id: "1729f790-2114-11e7-97f0-685b35cd61c2",
    medical_service_provider: %{
      licenses: [%{
        license_number: "10000"
      }],
      accreditation: %{
        category: "друга",
        order_no: "me789123"
      }
    }
  }

  @invalid_attrs %{
    is_active: false,
    addresses: nil,
    inserted_by: nil,
    edrpou: nil,
    email: nil,
    kveds: nil,
    legal_form: nil,
    name: nil,
    owner_property_type: nil,
    phones: nil,
    public_name: nil,
    short_name: nil,
    status: nil,
    type: nil,
    updated_by: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    fixture(:legal_entity)
    fixture(:legal_entity)
    fixture(:legal_entity)
    fixture(:legal_entity)

    conn = get conn, legal_entity_path(conn, :index, ["limit": 2])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 2 == length(resp["data"])
    assert resp["paging"]["has_more"]
  end

  test "lists entries by owner_property_type", %{conn: conn} do
    fixture(:legal_entity)
    legal_entity(true, "PRIVATE")

    conn = get conn, legal_entity_path(conn, :index, ["owner_property_type": "PRIVATE"])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 1 == length(resp["data"])
    refute resp["paging"]["has_more"]

    conn = get conn, legal_entity_path(conn, :index, ["owner_property_type": "invalid"])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 0 == length(resp["data"])
    refute resp["paging"]["has_more"]
  end

  test "lists entries by id", %{conn: conn} do
    fixture(:legal_entity)
    %{id: id} = fixture(:legal_entity)

    conn = get conn, legal_entity_path(conn, :index, [id: id])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 1 == length(resp["data"])
    assert id == List.first(resp["data"])["id"]
    refute resp["paging"]["has_more"]
  end

  test "lists entries by settlement_id", %{conn: conn} do
    fixture(:legal_entity)
    %{id: id, addresses: [%{"settlement_id" => settlement_id}]} = fixture(:legal_entity)

    conn = get conn, legal_entity_path(conn, :index, [settlement_id: settlement_id])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 1 == length(resp["data"])
    assert id == List.first(resp["data"])["id"]
    refute resp["paging"]["has_more"]
  end

  test "lists entries by legal_form", %{conn: conn} do
    fixture(:legal_entity)
    legal_entity(true, "PRIVATE", "P13")

    conn = get conn, legal_entity_path(conn, :index, ["legal_form": "P13"])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 1 == length(resp["data"])
    refute resp["paging"]["has_more"]
  end

  test "lists all entries with is_active flag", %{conn: conn} do
    fixture(:legal_entity)
    fixture(:legal_entity)
    fixture(:legal_entity)
    legal_entity(false)

    conn_resp = get conn, legal_entity_path(conn, :index, ["is_active": "true"])
    resp = json_response(conn_resp, 200)
    assert 3 == length(resp["data"])

    conn_resp = get conn, legal_entity_path(conn, :index, ["is_active": "false"])
    resp = json_response(conn_resp, 200)
    assert 1 == length(resp["data"])
  end

  test "unique edrpou", %{conn: conn} do
    %{edrpou: edrpou} = fixture(:legal_entity)
    legal_entity = fixture(:legal_entity)

    conn = put conn, legal_entity_path(conn, :update, legal_entity), %{edrpou: edrpou}
    json_response(conn, 422)
  end

  test "creates legal_entity and renders legal_entity when data is valid", %{conn: conn} do
    conn = post conn, legal_entity_path(conn, :create), @create_attrs
    assert %{"id" => id, "medical_service_provider" => _} = json_response(conn, 201)["data"]

    conn = get conn, legal_entity_path(conn, :show, id)
    response = json_response(conn, 200)["data"]

    assert id == response["id"]
    assert Map.has_key?(response, "updated_at")
    assert Map.has_key?(response, "inserted_at")
    assert Map.has_key?(response, "nhs_verified")
    assert response["is_active"]
    assert "026a8ea0-2114-11e7-8fae-685b35cd61c2" == response["inserted_by"]
    assert "VERIFIED" == response["status"]
    assert "MSP" == response["type"]
    assert "some legal_form" == response["legal_form"]
    assert "04512341" == response["edrpou"]
    assert "STATE" == response["owner_property_type"]
    assert "1729f790-2114-11e7-97f0-685b35cd61c2" == response["created_by_mis_client_id"]
    assert %{
       "accreditation" => %{
         "category" => "перша",
         "order_no" => "me789123"},
       "licenses" => [%{
         "license_number" => "fd123443"
       }]
     } == response["medical_service_provider"]
  end

  test "does not create legal_entity and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, legal_entity_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen legal_entity and renders legal_entity when data is valid", %{conn: conn} do
    %LegalEntity{id: id} = legal_entity = fixture(:legal_entity)
    conn = put conn, legal_entity_path(conn, :update, legal_entity), @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, legal_entity_path(conn, :show, id)
    response = json_response(conn, 200)["data"]

    assert id == response["id"]
    assert Map.has_key?(response, "updated_at")
    assert Map.has_key?(response, "inserted_at")
    assert response["nhs_verified"]
    refute response["is_active"]
    assert "4756170a-2114-11e7-8e8a-685b35cd61c2" == response["inserted_by"]
    assert "36cb4752-2114-11e7-96a7-685b35cd61c2" == response["updated_by"]
    assert "NOT_VERIFIED" == response["status"]
    assert "MIS" == response["type"]
    assert "04512322" == response["edrpou"]
    assert "PRIVATE" == response["owner_property_type"]
    assert "1729f790-2114-11e7-97f0-685b35cd61c2" == response["created_by_mis_client_id"]
    assert %{
       "accreditation" => %{
         "category" => "друга",
         "order_no" => "me789123"},
       "licenses" => [%{
         "license_number" => "10000"
       }]
     } == response["medical_service_provider"]
  end

  test "does not update chosen legal_entity and renders errors when data is invalid", %{conn: conn} do
    legal_entity = fixture(:legal_entity)
    conn = put conn, legal_entity_path(conn, :update, legal_entity), @invalid_attrs
    resp = json_response(conn, 422)
    assert Map.has_key?(resp, "error")
    assert resp["error"]
  end
end
