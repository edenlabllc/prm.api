defmodule PRM.Web.DoctorControllerTest do
  use PRM.Web.ConnCase

  alias PRM.DoctorAPI
  alias PRM.Doctor

  @create_attrs %{
    mpi_id: "some_mpi_id_string",
    status: "APPROVED",
    education: [],
    certificates: [],
    licenses: [],
    jobs: [],
    active: true,
    name: "Vasilii Poupkine",
    created_by: "some_author_identifier",
    updated_by: "some_editor_identifier"
  }

  @update_attrs %{
    mpi_id: "some_updated_updated_mpi_id_string",
    status: "DECLINED",
    education: [],
    certificates: [],
    licenses: [],
    jobs: [],
    active: false,
    name: "Vasilii Poupkine Updated",
    created_by: "some_updated_author_identifier",
    updated_by: "some_updated_editor_identifier"
  }

  # TODO: uncomment this along with pending tests below
  # @invalid_attrs %{}

  def fixture(:doctor) do
    {:ok, doctor} = DoctorAPI.create_doctor(@create_attrs)
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
      "mpi_id" => "some_mpi_id_string",
      "status" => "APPROVED",
      "education" => [],
      "certificates" => [],
      "licenses" => [],
      "jobs" => [],
      "active" => true,
      "name" => "Vasilii Poupkine",
      "created_by" => "some_author_identifier",
      "updated_by" => "some_editor_identifier",
      "type" => "doctor"
    }
  end

  @tag pending: true
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
      "mpi_id" => "some_updated_updated_mpi_id_string",
      "status" => "DECLINED",
      "education" => [],
      "certificates" => [],
      "licenses" => [],
      "jobs" => [],
      "active" => false,
      "name" => "Vasilii Poupkine Updated",
      "created_by" => "some_updated_author_identifier",
      "updated_by" => "some_updated_editor_identifier",
      "type" => "doctor"
    }
  end

  @tag pending: true
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

  test "search doctor by ids", %{conn: conn} do
    doctors_ids = for _ <- 1..3, do: fixture(:doctor).id
    doctors_ids = Enum.take_random(doctors_ids, 2)
    conn = get conn, doctor_path(conn, :index, %{"ids" => doctors_ids})

    assert response(conn, 200)
    response_data = json_response(conn, 200)["data"]

    assert is_list(response_data)
    assert 2 == length(response_data)
    assert Enum.all?(response_data, fn(%{"id" => id}) -> Enum.member?(doctors_ids, id) end)
  end

  test "return an empty list when search has no results", %{conn: conn} do
    for _ <- 1..3, do: fixture(:doctor).id
    conn = get conn, doctor_path(conn, :index, %{"ids" => ["76eaff1c-ea79-48c3-b6d6-1e4394a7ba52129"]})

    assert response(conn, 200)
    response_data = json_response(conn, 200)["data"]

    assert is_list(response_data)
    assert 0 == length(response_data)
  end

  test "search doctor invalid ids type", %{conn: conn} do
    conn = get conn, doctor_path(conn, :index, %{"ids" => "invalid type"})
    assert json_response(conn, 422)["errors"] != %{}
  end
end
