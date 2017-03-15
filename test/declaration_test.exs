defmodule PRM.DeclarationAPITest do
  use PRM.DataCase

  alias PRM.DeclarationAPI
  alias PRM.Declaration

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
    assert DeclarationAPI.list_declarations() == [declaration]
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

    assert declaration.title      == "some_title"
    assert declaration.specialty  == "some_specialty_string"
    assert declaration.start_date
    assert declaration.end_date
    assert declaration.active
    assert declaration.created_by == "some_author_identifier"
    assert declaration.updated_by == "some_editor_identifier"
    assert declaration.doctor_id
    assert declaration.msp_id
  end

  @tag pending: true
  test "create_declaration/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = DeclarationAPI.create_declaration(@invalid_attrs)
  end

  test "update_declaration/2 with valid data updates the declaration" do
    declaration = fixture(:declaration)
    assert {:ok, declaration} = DeclarationAPI.update_declaration(declaration, @update_attrs)
    assert %Declaration{} = declaration

    assert declaration.title      == "some_updated_title"
    assert declaration.specialty  == "some_updated_specialty_string"
    assert declaration.start_date
    assert declaration.end_date
    refute declaration.active
    assert declaration.created_by == "some_updated_author_identifier"
    assert declaration.updated_by == "some_updated_editor_identifier"
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
