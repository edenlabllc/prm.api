defmodule PRM.LabourContractAPITest do
  use PRM.DataCase

  alias PRM.LabourContractAPI
  alias PRM.LabourContract

  @create_attrs %{
    start_date: "2016-10-10 23:50:07.000000",
    end_date: "2016-12-07 23:50:07.000000",
    title: "some_title",
    specialty: "some_specialty_string",
    active: true,
    created_by: "some_author_identifier",
    updated_by: "some_editor_identifier"
  }

  @update_attrs %{
    start_date: "2016-10-11 23:50:07.000000",
    end_date: "2016-12-08 23:50:07.000000",
    title: "some_updated_title",
    specialty: "some_updated_specialty_string",
    active: false,
    created_by: "some_updated_author_identifier",
    updated_by: "some_updated_editor_identifier"
  }

  # TODO: unmark pending test cases below
  @invalid_attrs %{
  }

  def fixture(:labour_contract, attrs \\ @create_attrs) do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    {:ok, labour_contract} = LabourContractAPI.create_labour_contract(create_attrs)
    labour_contract
  end

  test "list_labour_contracts/1 returns all labour_contracts" do
    labour_contract = fixture(:labour_contract)
    assert LabourContractAPI.list_labour_contracts() == [labour_contract]
  end

  test "get_labour_contract! returns the labour_contract with given id" do
    labour_contract = fixture(:labour_contract)
    assert LabourContractAPI.get_labour_contract!(labour_contract.id) == labour_contract
  end

  test "create_labour_contract/1 with valid data creates a labour_contract" do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    assert {:ok, %LabourContract{} = labour_contract} = LabourContractAPI.create_labour_contract(create_attrs)

    assert labour_contract.title      == "some_title"
    assert labour_contract.specialty  == "some_specialty_string"
    assert labour_contract.start_date
    assert labour_contract.end_date
    assert labour_contract.active
    assert labour_contract.created_by == "some_author_identifier"
    assert labour_contract.updated_by == "some_editor_identifier"
    assert labour_contract.doctor_id
    assert labour_contract.msp_id
  end

  @tag pending: true
  test "create_labour_contract/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = LabourContractAPI.create_labour_contract(@invalid_attrs)
  end

  test "update_labour_contract/2 with valid data updates the labour_contract" do
    labour_contract = fixture(:labour_contract)
    assert {:ok, labour_contract} = LabourContractAPI.update_labour_contract(labour_contract, @update_attrs)
    assert %LabourContract{} = labour_contract

    assert labour_contract.title      == "some_updated_title"
    assert labour_contract.specialty  == "some_updated_specialty_string"
    assert labour_contract.start_date
    assert labour_contract.end_date
    refute labour_contract.active
    assert labour_contract.created_by == "some_updated_author_identifier"
    assert labour_contract.updated_by == "some_updated_editor_identifier"
    assert labour_contract.doctor_id
    assert labour_contract.msp_id
  end

  @tag pending: true
  test "update_labour_contract/2 with invalid data returns error changeset" do
    labour_contract = fixture(:labour_contract)
    assert {:error, %Ecto.Changeset{}} = LabourContractAPI.update_labour_contract(labour_contract, @invalid_attrs)
    assert labour_contract == API.get_labour_contract!(labour_contract.id)
  end

  test "delete_labour_contract/1 deletes the labour_contract" do
    labour_contract = fixture(:labour_contract)
    assert {:ok, %LabourContract{}} = LabourContractAPI.delete_labour_contract(labour_contract)
    assert_raise Ecto.NoResultsError, fn -> LabourContractAPI.get_labour_contract!(labour_contract.id) end
  end

  test "change_labour_contract/1 returns a labour_contract changeset" do
    labour_contract = fixture(:labour_contract)
    assert %Ecto.Changeset{} = LabourContractAPI.change_labour_contract(labour_contract)
  end
end
