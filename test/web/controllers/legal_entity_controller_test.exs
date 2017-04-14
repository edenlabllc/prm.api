defmodule PRM.Web.LegalEntityControllerTest do
  use PRM.Web.ConnCase

  alias PRM.Entities
  alias PRM.Entities.LegalEntity

  @create_attrs %{is_active: true, addresses: %{}, created_by: "some created_by", edrpou: "04512341", email: "some email", kveds: %{}, legal_form: "some legal_form", name: "some name", owner_property_type: "some owner_property_type", phones: %{}, public_name: "some public_name", short_name: "some short_name", status: "some status", type: "some type", updated_by: "some updated_by"}

  @update_attrs %{is_active: false, addresses: %{}, created_by: "some updated created_by", edrpou: 43, email: "some updated email", kveds: %{}, legal_form: "some updated legal_form", name: "some updated name", owner_property_type: "some updated owner_property_type", phones: %{}, public_name: "some updated public_name", short_name: "some updated short_name", status: "some updated status", type: "some updated type", updated_by: "some updated updated_by"}

  @invalid_attrs %{is_active: nil, addresses: nil, created_by: nil, edrpou: nil, email: nil, kveds: nil, legal_form: nil, name: nil, owner_property_type: nil, phones: nil, public_name: nil, short_name: nil, status: nil, type: nil, updated_by: nil}

  def fixture(:legal_entity) do
    {:ok, legal_entity} = Entities.create_legal_entity(@create_attrs)
    legal_entity
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, legal_entity_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates legal_entity and renders legal_entity when data is valid", %{conn: conn} do
    conn = post conn, legal_entity_path(conn, :create), @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, legal_entity_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "is_active" => true,
      "addresses" => %{},
      "created_by" => "some created_by",
      "edrpou" => 42,
      "email" => "some email",
      "kveds" => %{},
      "legal_form" => "some legal_form",
      "name" => "some name",
      "owner_property_type" => "some owner_property_type",
      "phones" => %{},
      "public_name" => "some public_name",
      "short_name" => "some short_name",
      "status" => "some status",
      "type" => "some type",
      "updated_by" => "some updated_by"}
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
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "is_active" => false,
      "addresses" => %{},
      "created_by" => "some updated created_by",
      "edrpou" => 43,
      "email" => "some updated email",
      "kveds" => %{},
      "legal_form" => "some updated legal_form",
      "name" => "some updated name",
      "owner_property_type" => "some updated owner_property_type",
      "phones" => %{},
      "public_name" => "some updated public_name",
      "short_name" => "some updated short_name",
      "status" => "some updated status",
      "type" => "some updated type",
      "updated_by" => "some updated updated_by"}
  end

  test "does not update chosen legal_entity and renders errors when data is invalid", %{conn: conn} do
    legal_entity = fixture(:legal_entity)
    conn = put conn, legal_entity_path(conn, :update, legal_entity), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
