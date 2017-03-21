defmodule PRM.DeclarationAPITest do
  use PRM.DataCase

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

  # TODO: unmark pending test cases below
  @invalid_attrs %{
  }

  def fixture(:declaration, attrs \\ @create_attrs) do
    create_attrs =
      attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    {:ok, declaration} = DeclarationAPI.create_declaration(create_attrs)
    declaration
  end

  test "list_declarations/1 returns all declarations" do
    declaration = fixture(:declaration)
    assert DeclarationAPI.list_declarations(%{}) == {:ok, [declaration]}
  end

  test "get_declaration! returns the declaration with given id" do
    declaration = fixture(:declaration)
    assert DeclarationAPI.get_declaration!(declaration.id) == declaration
  end

  test "create_declaration/1 with valid data creates a declaration" do
    create_attrs =
      @create_attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    assert {:ok, %Declaration{} = declaration} = DeclarationAPI.create_declaration(create_attrs)

    assert declaration.patient_id == create_attrs.patient_id
    assert declaration.start_date
    assert declaration.end_date
    assert declaration.signature == "some_signrature_string"
    assert declaration.certificate == "some_certificate_string"
    assert declaration.status == "some_status_string"
    assert declaration.signed_at
    assert declaration.created_by == "some_author_identifier"
    assert declaration.updated_by == "some_editor_identifier"
    assert declaration.confident_person_id == create_attrs.confident_person_id
    assert declaration.active
    assert declaration.doctor_id == create_attrs.doctor_id
    assert declaration.msp_id == create_attrs.msp_id
  end

  @tag pending: true
  test "create_declaration/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = DeclarationAPI.create_declaration(@invalid_attrs)
  end

  test "update_declaration/2 with valid data updates the declaration" do
    declaration = fixture(:declaration)
    assert {:ok, declaration} = DeclarationAPI.update_declaration(declaration, @update_attrs)
    assert %Declaration{} = declaration

    assert declaration.patient_id == @update_attrs.patient_id
    assert declaration.start_date
    assert declaration.end_date
    assert declaration.signature == "some_updated_signrature_string"
    assert declaration.certificate == "some_updated_certificate_string"
    assert declaration.status == "some_updated_status_string"
    assert declaration.signed_at
    assert declaration.created_by == "some_updated_author_identifier"
    assert declaration.updated_by == "some_updated_editor_identifier"
    assert declaration.confident_person_id == @update_attrs.confident_person_id
    refute declaration.active
    assert declaration.doctor_id
    assert declaration.msp_id
  end

  @tag pending: true
  test "update_declaration/2 with invalid data returns error changeset" do
    declaration = fixture(:declaration)
    assert {:error, %Ecto.Changeset{}} = DeclarationAPI.update_declaration(declaration, @invalid_attrs)
    assert declaration == API.get_declaration!(declaration.id)
  end

  test "delete_declaration/1 deletes the declaration" do
    declaration = fixture(:declaration)
    assert {:ok, %Declaration{}} = DeclarationAPI.delete_declaration(declaration)
    assert_raise Ecto.NoResultsError, fn -> DeclarationAPI.get_declaration!(declaration.id) end
  end

  test "change_declaration/1 returns a declaration changeset" do
    declaration = fixture(:declaration)
    assert %Ecto.Changeset{} = DeclarationAPI.change_declaration(declaration)
  end
end
