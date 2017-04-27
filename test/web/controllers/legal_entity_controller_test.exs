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
    conn = get conn, legal_entity_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
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
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "is_active" => true,
      "addresses" => [%{}],
      "inserted_by" => "026a8ea0-2114-11e7-8fae-685b35cd61c2",
      "edrpou" => "04512341",
      "email" => "some email",
      "kveds" => [],
      "legal_form" => "some legal_form",
      "name" => "some name",
      "owner_property_type" => "STATE",
      "phones" => [%{}],
      "public_name" => "some public_name",
      "short_name" => "some short_name",
      "status" => "VERIFIED",
      "type" => "MSP",
      "updated_by" => "1729f790-2114-11e7-97f0-685b35cd61c2",
      "medical_service_provider" => %{
        "accreditation" => %{
          "category" => "перша",
          "order_no" => "me789123"},
        "licenses" => [%{
          "license_number" => "fd123443"
        }]
      }
    }
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
    assert response == %{
      "id" => id,
      "is_active" => false,
      "addresses" => [%{}],
      "inserted_by" => "4756170a-2114-11e7-8e8a-685b35cd61c2",
      "edrpou" => "04512322",
      "email" => "some updated email",
      "kveds" => [],
      "legal_form" => "some updated legal_form",
      "name" => "some updated name",
      "owner_property_type" => "PRIVATE",
      "phones" => [%{}],
      "public_name" => "some updated public_name",
      "short_name" => "some updated short_name",
      "status" => "NOT_VERIFIED",
      "type" => "MIS",
      "updated_by" => "36cb4752-2114-11e7-96a7-685b35cd61c2",
      "medical_service_provider" => %{
        "accreditation" => %{
          "category" => "друга",
          "order_no" => "me789123"},
        "licenses" => [%{
          "license_number" => "10000"
        }]
      }
    }
  end

  test "does not update chosen legal_entity and renders errors when data is invalid", %{conn: conn} do
    legal_entity = fixture(:legal_entity)
    conn = put conn, legal_entity_path(conn, :update, legal_entity), @invalid_attrs
    resp = json_response(conn, 422)
    assert Map.has_key?(resp, "error")
    assert resp["error"]
  end
end
