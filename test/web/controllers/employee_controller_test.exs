defmodule PRM.Web.EmployeeControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias PRM.Repo
  alias PRM.Employees.Employee

  @update_attrs %{
    is_active: false,
    position: "some updated position",
    status: "some updated status",
    start_date: "2011-06-18",
    inserted_by: "7488a646-e31f-11e4-aace-600308960668",
    updated_by: "7488a646-e31f-11e4-aace-600308960668"
  }

  @invalid_attrs %{
    employee_type: "invalid",
    is_active: false,
    position: "some updated position",
    status: "some updated status",
    start_date: "2011-06-18",
    inserted_by: "",
    updated_by: "7488a646-e31f-11e4-aace-600308960668"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    employee("DOCTOR")
    employee("accountant")
    employee("DOCTOR")
    employee("hr")

    conn = get conn, employee_path(conn, :index, [limit: 2])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 2 == length(resp["data"])
    assert resp["paging"]["has_more"]

    employee = resp |> Map.get("data") |> List.first()
    refute employee["party"]
    refute employee["division"]
    refute employee["legal_entity"]
  end

  test "lists with expanded associations", %{conn: conn} do
    employee("DOCTOR")
    employee("accountant")
    employee("DOCTOR")
    employee("hr")

    conn = get conn, employee_path(conn, :index, %{"expand" => false})
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 4 == length(resp["data"])
    refute resp["paging"]["has_more"]

    employee = resp |> Map.get("data") |> List.first()

    assert Map.has_key?(employee, "doctor")
    assert Map.has_key?(employee["doctor"], "id")
    assert is_map(employee["party"])
    assert is_map(employee["division"])
    assert is_map(employee["legal_entity"])
    refute Map.has_key?(employee, "party_id")
    refute Map.has_key?(employee, "division_id")
    refute Map.has_key?(employee, "legal_entity_id")
  end

  test "search employee by employee_type", %{conn: conn} do
    employee("DOCTOR")
    employee("accountant")
    employee("DOCTOR")
    employee("hr")

    conn = get conn, employee_path(conn, :index, [employee_type: "accountant"])
    assert 1 == length(json_response(conn, 200)["data"])

    conn = get conn, employee_path(conn, :index, [employee_type: "DOCTOR"])
    assert 2 == length(json_response(conn, 200)["data"])
  end

  test "search employee by tax_id", %{conn: conn} do
    doctor = "DOCTOR" |> employee() |> Repo.preload(:party)
    accountant = "accountant" |> employee() |> Repo.preload(:party)
    ids = Enum.map([doctor, accountant], &(&1.id))

    conn = get conn, employee_path(conn, :index, [tax_id: doctor.party.tax_id])
    resp = json_response(conn, 200)["data"]
    assert 2 == length(resp)
    assert Enum.all?(resp, &(Enum.member?(ids, Map.get(&1, "id"))))

    conn = get conn, employee_path(conn, :index, [tax_id: "invalid tax id"])
    assert 0 == length(json_response(conn, 200)["data"])
  end

  test "search employee by edrpou", %{conn: conn} do
    doctor = "DOCTOR" |> employee() |> Repo.preload(:legal_entity)
    accountant = "accountant" |> employee() |> Repo.preload(:legal_entity)

    conn = get conn, employee_path(conn, :index, [edrpou: doctor.legal_entity.edrpou])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert Enum.at(resp, 0)["id"] == doctor.id

    conn = get conn, employee_path(conn, :index, [edrpou: accountant.legal_entity.edrpou])
    resp = json_response(conn, 200)["data"]
    assert 1 == length(resp)
    assert Enum.at(resp, 0)["id"] == accountant.id

    conn = get conn, employee_path(conn, :index, [edrpou: "invalid edrpou"])
    assert 0 == length(json_response(conn, 200)["data"])
  end

  test "search employees by legal_entity_id", %{conn: conn} do
    hr = "hr" |> employee() |> Repo.preload(:legal_entity)

    conn = get conn, employee_path(conn, :index, [legal_entity_id: hr.legal_entity.id])
    assert 1 == length(json_response(conn, 200)["data"])

    conn = get conn, employee_path(conn, :index, [legal_entity_id: Ecto.UUID.generate()])
    assert 0 == length(json_response(conn, 200)["data"])
  end

  test "creates employee and renders employee when data is valid", %{conn: conn} do
    %{id: party_id} = party()
    %{id: division_id} = division()
    %{id: legal_entity_id} = legal_entity()

    attrs = %{
      is_active: true,
      position: "some position",
      status: "some status",
      employee_type: "hr",
      end_date: ~D[2011-04-17],
      start_date: ~D[2010-04-17],
      inserted_by: "7488a646-e31f-11e4-aace-600308960662",
      updated_by: "7488a646-e31f-11e4-aace-600308960662",
      party_id: party_id,
      division_id: division_id,
      legal_entity_id: legal_entity_id,
    }

    conn = post conn, employee_path(conn, :create), attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, employee_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "employee_type" => "hr",
      "is_active" => true,
      "status" => "some status",
      "position" => "some position",
      "end_date" => "2011-04-17",
      "start_date" => "2010-04-17",
      "inserted_by" => "7488a646-e31f-11e4-aace-600308960662",
      "updated_by" => "7488a646-e31f-11e4-aace-600308960662",
      "party_id" => party_id,
      "division_id" => division_id,
      "legal_entity_id" => legal_entity_id,
    }
  end

  test "does not create employee and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, employee_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen employee and renders employee when data is valid", %{conn: conn} do
    %Employee{id: id} = employee = fixture(:employee)
    conn = put conn, employee_path(conn, :update, employee), @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, employee_path(conn, :show, id)
    resp = json_response(conn, 200)["data"]

    assert resp["id"] == id
    assert resp["employee_type"] == "DOCTOR"
    assert resp["start_date"] == "2011-06-18"
    refute resp["is_active"]

    assert Map.has_key?(resp, "doctor")
    assert  Map.has_key?(resp["doctor"], "educations")
    assert  Map.has_key?(resp["doctor"], "specialities")
    assert  Map.has_key?(resp["doctor"], "qualifications")
    assert  Map.has_key?(resp["doctor"], "science_degree")

  end

  test "does not update chosen employee and renders errors when data is invalid", %{conn: conn} do
    employee = fixture(:employee)
    conn = put conn, employee_path(conn, :update, employee), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
