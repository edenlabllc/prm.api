defmodule PRM.Web.MSPControllerTest do
  use PRM.Web.ConnCase

  alias PRM.MSPAPI
  alias PRM.MSP

  @create_attrs %{
    name: "some_name",
    short_name: "some_shortname_string",
    type: "some_type_string",
    edrpou: "some_edrpou_string",
    services: [],
    licenses: [],
    accreditations: [],
    addresses: [],
    phones: [],
    emails: [],
    created_by: "some_author_identifier",
    updated_by: "some_editor_identifier",
    active: true
  }

  @update_attrs %{
    name: "some_updated_name",
    short_name: "some_updated_shortname_string",
    type: "some_updated_type_string",
    edrpou: "some_updated_edrpou_string",
    services: [],
    licenses: [],
    accreditations: [],
    addresses: [],
    phones: [],
    emails: [],
    created_by: "some_updated_author_identifier",
    updated_by: "some_updated_editor_identifier",
    active: false
  }

  # TODO: uncomment this along with pending tests below
  # @invalid_attrs %{}

  def fixture(:msp) do
    {:ok, msp} = MSPAPI.create_msp(@create_attrs)
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
      "name" => "some_name",
      "short_name" => "some_shortname_string",
      "type" => "some_type_string",
      "edrpou" => "some_edrpou_string",
      "services" => [],
      "licenses" => [],
      "accreditations" => [],
      "addresses" => [],
      "phones" => [],
      "emails" => [],
      "created_by" => "some_author_identifier",
      "updated_by" => "some_editor_identifier",
      "active" => true
    }
  end

  @tag pending: true
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
      "name" => "some_updated_name",
      "short_name" => "some_updated_shortname_string",
      "type" => "some_updated_type_string",
      "edrpou" => "some_updated_edrpou_string",
      "services" => [],
      "licenses" => [],
      "accreditations" => [],
      "addresses" => [],
      "phones" => [],
      "emails" => [],
      "created_by" => "some_updated_author_identifier",
      "updated_by" => "some_updated_editor_identifier",
      "active" => false
    }
  end

  @tag pending: true
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
