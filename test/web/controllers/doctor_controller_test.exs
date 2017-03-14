defmodule PRM.Web.DoctorControllerTest do
  use PRM.Web.ConnCase

  alias PRM.API
  alias PRM.API.Doctor

  @create_attrs %{thing: "some thing"}
  @update_attrs %{thing: "some updated thing"}
  @invalid_attrs %{thing: nil}

  def fixture(:doctor) do
    {:ok, doctor} = API.create_doctor(@create_attrs)
    doctor
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, doctor_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates doctor and renders doctor when data is valid", %{conn: conn} do
    conn = post conn, doctor_path(conn, :create), doctor: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, doctor_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "thing" => "some thing"}
  end

  test "does not create doctor and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, doctor_path(conn, :create), doctor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen doctor and renders doctor when data is valid", %{conn: conn} do
    %Doctor{id: id} = doctor = fixture(:doctor)
    conn = put conn, doctor_path(conn, :update, doctor), doctor: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, doctor_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "thing" => "some updated thing"}
  end

  test "does not update chosen doctor and renders errors when data is invalid", %{conn: conn} do
    doctor = fixture(:doctor)
    conn = put conn, doctor_path(conn, :update, doctor), doctor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen doctor", %{conn: conn} do
    doctor = fixture(:doctor)
    conn = delete conn, doctor_path(conn, :delete, doctor)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, doctor_path(conn, :show, doctor)
    end
  end
end
