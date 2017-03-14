defmodule PRM.APITest do
  use PRM.DataCase

  alias PRM.API
  alias PRM.API.Doctor

  @create_attrs %{thing: "some thing"}
  @update_attrs %{thing: "some updated thing"}
  @invalid_attrs %{thing: nil}

  def fixture(:doctor, attrs \\ @create_attrs) do
    {:ok, doctor} = API.create_doctor(attrs)
    doctor
  end

  test "list_doctors/1 returns all doctors" do
    doctor = fixture(:doctor)
    assert API.list_doctors() == [doctor]
  end

  test "get_doctor! returns the doctor with given id" do
    doctor = fixture(:doctor)
    assert API.get_doctor!(doctor.id) == doctor
  end

  test "create_doctor/1 with valid data creates a doctor" do
    assert {:ok, %Doctor{} = doctor} = API.create_doctor(@create_attrs)

    assert doctor.thing == "some thing"
  end

  test "create_doctor/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = API.create_doctor(@invalid_attrs)
  end

  test "update_doctor/2 with valid data updates the doctor" do
    doctor = fixture(:doctor)
    assert {:ok, doctor} = API.update_doctor(doctor, @update_attrs)
    assert %Doctor{} = doctor

    assert doctor.thing == "some updated thing"
  end

  test "update_doctor/2 with invalid data returns error changeset" do
    doctor = fixture(:doctor)
    assert {:error, %Ecto.Changeset{}} = API.update_doctor(doctor, @invalid_attrs)
    assert doctor == API.get_doctor!(doctor.id)
  end

  test "delete_doctor/1 deletes the doctor" do
    doctor = fixture(:doctor)
    assert {:ok, %Doctor{}} = API.delete_doctor(doctor)
    assert_raise Ecto.NoResultsError, fn -> API.get_doctor!(doctor.id) end
  end

  test "change_doctor/1 returns a doctor changeset" do
    doctor = fixture(:doctor)
    assert %Ecto.Changeset{} = API.change_doctor(doctor)
  end
end
