defmodule PRM.Web.LegalEntityControllerTest do
  @moduledoc false

  use PRM.Web.ConnCase

  alias PRM.Entities.LegalEntity

  import PRM.SimpleFactory

  @create_attrs %{
    is_active: true,
    addresses: %{},
    created_by: "some created_by",
    edrpou: "04512341",
    email: "some email",
    kveds: %{},
    legal_form: "some legal_form",
    name: "some name",
    owner_property_type: "STATE",
    phones: %{},
    public_name: "some public_name",
    short_name: "some short_name",
    status: "VERIFIED",
    type: "MSP",
    updated_by: "some updated_by",
    medical_service_provider: %{
      license: %{
        license_number: "fd123443"
      },
      accreditation: %{
        category: "перша",
        order_no: "me789123"
      }
    }
  }

  @update_attrs %{
    is_active: false,
    addresses: %{},
    created_by: "some updated created_by",
    edrpou: "04512322",
    email: "some updated email",
    kveds: %{},
    legal_form: "some updated legal_form",
    name: "some updated name",
    owner_property_type: "PRIVATE",
    phones: %{},
    public_name: "some updated public_name",
    short_name: "some updated short_name",
    status: "NOT_VERIFIED",
    type: "MIS",
    updated_by: "some updated updated_by",
    medical_service_provider: %{
      license: %{
        license_number: "10000"
      },
      accreditation: %{
        category: "друга",
        order_no: "me789123"
      }
    }
  }

  @invalid_attrs %{
    is_active: false,
    addresses: nil,
    created_by: nil,
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

  test "creates legal_entity and renders legal_entity when data is valid", %{conn: conn} do
    conn = post conn, legal_entity_path(conn, :create), @create_attrs
    assert %{"id" => id, "medical_service_provider" => msp} = json_response(conn, 201)["data"]

    assert Map.has_key?(msp, "license")
    assert Map.has_key?(msp["license"], "license_number")
    assert Map.has_key?(msp, "accreditation")
    assert Map.has_key?(msp["accreditation"], "category")
    assert Map.has_key?(msp["accreditation"], "order_no")

    assert msp["license"]["license_number"] == "fd123443"
    assert msp["accreditation"]["category"] == "перша"
    assert msp["accreditation"]["order_no"] == "me789123"

    conn = get conn, legal_entity_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "is_active" => true,
      "addresses" => %{},
      "created_by" => "some created_by",
      "edrpou" => "04512341",
      "email" => "some email",
      "kveds" => %{},
      "legal_form" => "some legal_form",
      "name" => "some name",
      "owner_property_type" => "STATE",
      "phones" => %{},
      "public_name" => "some public_name",
      "short_name" => "some short_name",
      "status" => "VERIFIED",
      "type" => "MSP",
      "updated_by" => "some updated_by",
      "medical_service_provider" => %{
        "accreditation" => %{
          "category" => "перша",
          "order_no" => "me789123"},
        "license" => %{
          "license_number" => "fd123443"
        }
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
      "addresses" => %{},
      "created_by" => "some updated created_by",
      "edrpou" => "04512322",
      "email" => "some updated email",
      "kveds" => %{},
      "legal_form" => "some updated legal_form",
      "name" => "some updated name",
      "owner_property_type" => "PRIVATE",
      "phones" => %{},
      "public_name" => "some updated public_name",
      "short_name" => "some updated short_name",
      "status" => "NOT_VERIFIED",
      "type" => "MIS",
      "updated_by" => "some updated updated_by",
      "medical_service_provider" => %{
        "accreditation" => %{
          "category" => "друга",
          "order_no" => "me789123"},
        "license" => %{
          "license_number" => "10000"
        }
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
