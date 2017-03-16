defmodule PRM.Web.DeclarationControllerTest do
  use PRM.Web.ConnCase

  alias PRM.DeclarationAPI
  alias PRM.Declaration

  @create_attrs %{
    patient_id: Ecto.UUID.generate(),
    start_date: "2016-10-10 23:50:07.000000",
    end_date: "2016-12-07 23:50:07.000000",
    signature: "some_signrature_string",
    certificate: "some_certificate_string",
    status: "some_status_string",
    signed_at: "2016-10-09 23:50:07.000000",
    created_by: "some_author_identifier",
    updated_by: "some_editor_identifier",
    confident_person_id: Ecto.UUID.generate(),
    active: true
  }

  @update_attrs %{
    patient_id: Ecto.UUID.generate(),
    start_date: "2016-10-11 23:50:07.000000",
    end_date: "2016-12-09 23:50:07.000000",
    signature: "some_updated_signrature_string",
    certificate: "some_updated_certificate_string",
    status: "some_updated_status_string",
    signed_at: "2016-10-10 23:50:07.000000",
    created_by: "some_updated_author_identifier",
    updated_by: "some_updated_editor_identifier",
    confident_person_id: Ecto.UUID.generate(),
    active: false
  }

  # TODO: uncomment this along with pending tests below
  # @invalid_attrs %{}

  def fixture(:declaration) do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    {:ok, declaration} = DeclarationAPI.create_declaration(create_attrs)
    declaration
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, declaration_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates declaration and renders declaration when data is valid", %{conn: conn} do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    conn = post conn, declaration_path(conn, :create), declaration: create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, declaration_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "patient_id" => create_attrs.patient_id,
      "start_date" => "2016-10-10T23:50:07.000000Z",
      "end_date" => "2016-12-07T23:50:07.000000Z",
      "signature" => "some_signrature_string",
      "certificate" => "some_certificate_string",
      "status" => "some_status_string",
      "signed_at" => "2016-10-09T23:50:07.000000Z",
      "created_by" => "some_author_identifier",
      "updated_by" => "some_editor_identifier",
      "confident_person_id" => create_attrs.confident_person_id,
      "doctor_id" => create_attrs.doctor_id,
      "msp_id" => create_attrs.msp_id,
      "type" => "declaration"
    }
  end

  @tag pending: true
  test "does not create declaration and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, declaration_path(conn, :create), declaration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen declaration and renders declaration when data is valid", %{conn: conn} do
    %Declaration{id: id} = declaration = fixture(:declaration)
    conn = put conn, declaration_path(conn, :update, declaration), declaration: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, declaration_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "patient_id" => @update_attrs.patient_id,
      "start_date" => "2016-10-11T23:50:07.000000Z",
      "end_date" => "2016-12-09T23:50:07.000000Z",
      "signature" => "some_updated_signrature_string",
      "certificate" => "some_updated_certificate_string",
      "status" => "some_updated_status_string",
      "signed_at" => "2016-10-10T23:50:07.000000Z",
      "created_by" => "some_updated_author_identifier",
      "updated_by" => "some_updated_editor_identifier",
      "confident_person_id" => @update_attrs.confident_person_id,
      "doctor_id" => declaration.doctor_id,
      "msp_id" => declaration.msp_id,
      "type" => "declaration"
    }
  end

  @tag pending: true
  test "does not update chosen declaration and renders errors when data is invalid", %{conn: conn} do
    declaration = fixture(:declaration)
    conn = put conn, declaration_path(conn, :update, declaration), declaration: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen declaration", %{conn: conn} do
    declaration = fixture(:declaration)
    conn = delete conn, declaration_path(conn, :delete, declaration)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, declaration_path(conn, :show, declaration)
    end
  end
end
