defmodule PRM.DoctorAPITest do
  use PRM.DataCase

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

  # TODO: unmark pending test cases below
  @invalid_attrs %{
  }

  def fixture(:doctor, attrs \\ @create_attrs) do
    {:ok, doctor} = DoctorAPI.create_doctor(attrs)
    doctor
  end

  test "list_doctors/1 returns all doctors" do
    doctor = fixture(:doctor)
    assert DoctorAPI.list_doctors() == [doctor]
  end

  test "get_doctor! returns the doctor with given id" do
    doctor = fixture(:doctor)
    assert DoctorAPI.get_doctor!(doctor.id) == doctor
  end

  test "create_doctor/1 with valid data creates a doctor" do
    assert {:ok, %Doctor{} = doctor} = DoctorAPI.create_doctor(@create_attrs)

    assert doctor.mpi_id == "some_mpi_id_string"
    assert doctor.status == "APPROVED"
    assert doctor.education == []
    assert doctor.certificates == []
    assert doctor.licenses == []
    assert doctor.jobs == []
    assert doctor.active
    assert doctor.name == "Vasilii Poupkine"
    assert doctor.created_by == "some_author_identifier"
    assert doctor.updated_by == "some_editor_identifier"
  end

  @tag pending: true
  test "create_doctor/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = DoctorAPI.create_doctor(@invalid_attrs)
  end

  test "update_doctor/2 with valid data updates the doctor" do
    doctor = fixture(:doctor)
    assert {:ok, doctor} = DoctorAPI.update_doctor(doctor, @update_attrs)
    assert %Doctor{} = doctor

    assert doctor.mpi_id == "some_updated_updated_mpi_id_string"
    assert doctor.status == "DECLINED"
    assert doctor.education == []
    assert doctor.certificates == []
    assert doctor.licenses == []
    assert doctor.jobs == []
    refute doctor.active
    assert doctor.name == "Vasilii Poupkine Updated"
    assert doctor.created_by == "some_updated_author_identifier"
    assert doctor.updated_by == "some_updated_editor_identifier"
  end

  @tag pending: true
  test "update_doctor/2 with invalid data returns error changeset" do
    doctor = fixture(:doctor)
    assert {:error, %Ecto.Changeset{}} = DoctorAPI.update_doctor(doctor, @invalid_attrs)
    assert doctor == API.get_doctor!(doctor.id)
  end

  test "delete_doctor/1 deletes the doctor" do
    doctor = fixture(:doctor)
    assert {:ok, %Doctor{}} = DoctorAPI.delete_doctor(doctor)
    assert_raise Ecto.NoResultsError, fn -> DoctorAPI.get_doctor!(doctor.id) end
  end

  test "change_doctor/1 returns a doctor changeset" do
    doctor = fixture(:doctor)
    assert %Ecto.Changeset{} = DoctorAPI.change_doctor(doctor)
  end

  test "success search doctors by ids" do
    doctor = fixture(:doctor)

    assert {:ok, [found_doctor]} = DoctorAPI.search_doctors(%{"ids" => [doctor.id]})
    assert doctor.id == found_doctor.id
  end
end
