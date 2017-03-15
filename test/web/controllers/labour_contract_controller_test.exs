defmodule PRM.Web.LabourContractControllerTest do
  use PRM.Web.ConnCase

  alias PRM.LabourContractAPI
  alias PRM.LabourContract

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

  def fixture(:labour_contract) do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    {:ok, labour_contract} = LabourContractAPI.create_labour_contract(create_attrs)
    labour_contract
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, labour_contract_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates labour_contract and renders labour_contract when data is valid", %{conn: conn} do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    conn = post conn, labour_contract_path(conn, :create), labour_contract: create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, labour_contract_path(conn, :show, id)
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
      "type" => "labour_contract"
    }
  end

  @tag pending: true
  test "does not create labour_contract and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, labour_contract_path(conn, :create), labour_contract: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen labour_contract and renders labour_contract when data is valid", %{conn: conn} do
    %LabourContract{id: id} = labour_contract = fixture(:labour_contract)
    conn = put conn, labour_contract_path(conn, :update, labour_contract), labour_contract: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, labour_contract_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "start_date" => "2016-10-11T23:50:07.000000Z",
      "end_date" => "2016-12-08T23:50:07.000000Z",
      "title" =>"some_updated_title",
      "specialty" =>"some_updated_specialty_string",
      "active" =>false,
      "created_by" =>"some_updated_author_identifier",
      "updated_by" =>"some_updated_editor_identifier",
      "doctor_id" => labour_contract.doctor_id,
      "msp_id" => labour_contract.msp_id,
      "type" => "labour_contract"
    }
  end

  @tag pending: true
  test "does not update chosen labour_contract and renders errors when data is invalid", %{conn: conn} do
    labour_contract = fixture(:labour_contract)
    conn = put conn, labour_contract_path(conn, :update, labour_contract), labour_contract: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen labour_contract", %{conn: conn} do
    labour_contract = fixture(:labour_contract)
    conn = delete conn, labour_contract_path(conn, :delete, labour_contract)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, labour_contract_path(conn, :show, labour_contract)
    end
  end
end
