defmodule PRM.Web.DeclarationControllerTest do
  use PRM.Web.ConnCase

  alias PRM.DeclarationAPI
  alias PRM.Declaration

  @create_attrs %{
    start_date: "2016-10-10 23:50:07",
    end_date: "2016-12-07 23:50:07",
    title: "some_title",
    specialty: "some_specialty_string",
    active: true,
    created_by: "some_author_identifier",
    updated_by: "some_editor_identifier"
  }

  @update_attrs %{
    start_date: "2016-10-11 23:50:07",
    end_date: "2016-12-08 23:50:07",
    title: "some_updated_title",
    specialty: "some_updated_specialty_string",
    active: false,
    created_by: "some_updated_author_identifier",
    updated_by: "some_updated_editor_identifier"
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
      "start_date" => "2016-10-10T23:50:07.000000Z",
      "end_date" => "2016-12-07T23:50:07.000000Z",
      "title" => "some_title",
      "specialty" => "some_specialty_string",
      "active" => true,
      "created_by" => "some_author_identifier",
      "updated_by" => "some_editor_identifier",
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
      "start_date" => "2016-10-11T23:50:07.000000Z",
      "end_date" => "2016-12-08T23:50:07.000000Z",
      "title" => "some_updated_title",
      "specialty" => "some_updated_specialty_string",
      "active" => false,
      "created_by" => "some_updated_author_identifier",
      "updated_by" => "some_updated_editor_identifier",
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
