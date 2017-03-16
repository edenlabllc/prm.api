defmodule PRM.MSPAPITest do
  use PRM.DataCase

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

  # TODO: unmark pending test cases below
  @invalid_attrs %{
  }

  def fixture(:msp, attrs \\ @create_attrs) do
    {:ok, msp} = MSPAPI.create_msp(attrs)
    msp
  end

  test "list_msps/1 returns all msps" do
    msp = fixture(:msp)
    assert MSPAPI.list_msps() == [msp]
  end

  test "get_msp! returns the msp with given id" do
    msp = fixture(:msp)
    assert MSPAPI.get_msp!(msp.id) == msp
  end

  test "create_msp/1 with valid data creates a msp" do
    assert {:ok, %MSP{} = msp} = MSPAPI.create_msp(@create_attrs)

    assert msp.name == "some_name"
    assert msp.short_name == "some_shortname_string"
    assert msp.type == "some_type_string"
    assert msp.edrpou == "some_edrpou_string"
    assert msp.services == []
    assert msp.licenses == []
    assert msp.accreditations == []
    assert msp.addresses == []
    assert msp.phones == []
    assert msp.emails == []
    assert msp.created_by == "some_author_identifier"
    assert msp.updated_by == "some_editor_identifier"
    assert msp.active
  end

  @tag pending: true
  test "create_msp/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = MSPAPI.create_msp(@invalid_attrs)
  end

  test "update_msp/2 with valid data updates the msp" do
    msp = fixture(:msp)
    assert {:ok, msp} = MSPAPI.update_msp(msp, @update_attrs)
    assert %MSP{} = msp

    assert msp.name == "some_updated_name"
    assert msp.short_name == "some_updated_shortname_string"
    assert msp.type == "some_updated_type_string"
    assert msp.edrpou == "some_updated_edrpou_string"
    assert msp.services == []
    assert msp.licenses == []
    assert msp.accreditations == []
    assert msp.addresses == []
    assert msp.phones == []
    assert msp.emails == []
    assert msp.created_by == "some_updated_author_identifier"
    assert msp.updated_by == "some_updated_editor_identifier"
    refute msp.active
  end

  @tag pending: true
  test "update_msp/2 with invalid data returns error changeset" do
    msp = fixture(:msp)
    assert {:error, %Ecto.Changeset{}} = MSPAPI.update_msp(msp, @invalid_attrs)
    assert msp == API.get_msp!(msp.id)
  end

  test "delete_msp/1 deletes the msp" do
    msp = fixture(:msp)
    assert {:ok, %MSP{}} = MSPAPI.delete_msp(msp)
    assert_raise Ecto.NoResultsError, fn -> MSPAPI.get_msp!(msp.id) end
  end

  test "change_msp/1 returns a msp changeset" do
    msp = fixture(:msp)
    assert %Ecto.Changeset{} = MSPAPI.change_msp(msp)
  end
end
