defmodule PRM.DoctorAPI do
  @moduledoc """
  The boundary for the DoctorAPI system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Doctor
  alias PRM.DoctorSearch

  def list_doctors do
    Repo.all(Doctor)
  end

  def get_doctor!(id), do: Repo.get!(Doctor, id)

  def create_doctor(attrs \\ %{}) do
    %Doctor{}
    |> doctor_changeset(attrs)
    |> Repo.insert()
  end

  def update_doctor(%Doctor{} = doctor, attrs) do
    doctor
    |> doctor_changeset(attrs)
    |> Repo.update()
  end

  def delete_doctor(%Doctor{} = doctor) do
    Repo.delete(doctor)
  end

  def change_doctor(%Doctor{} = doctor) do
    doctor_changeset(doctor, %{})
  end

  def search_doctor(attrs) do
    attrs
    |> DoctorSearch.validate()
  end

  defp doctor_changeset(%Doctor{} = doctor, attrs) do
    fields = ~W(
      mpi_id
      status
      jobs
      active
      name
      created_by
      updated_by
    )

    available_statuses = [
      "PENDING_APPROVAL",
      "APPROVED",
      "DECLINED"
    ]

    doctor
    |> cast(attrs, fields)
    |> cast_embed(:education, with: &education_changeset/2)
    |> cast_embed(:certificates, with: &certificate_changeset/2)
    |> cast_embed(:licenses, with: &medical_license_changeset/2)
    |> validate_inclusion(:status, available_statuses)
  end

  defp education_changeset(education, attrs) do
    education_fields = ~W(
      institution_name
      certificate_number
      degree
      start_date
      finished_date
      speciality
    )

    required_fields = [
      :institution_name,
      :certificate_number,
      :degree,
      :start_date,
      :finished_date,
      :speciality
    ]

    available_degrees = [
      "Doctor of Medicine",
      "Bachelor of Medicine",
      "Bachelor of Surgery",
      "Doctor of Osteopathic Medicine",
      "Master of Clinical Medicine"
    ]

    available_specialities = [
      "Загальна практика - сімейна медицина",
      "Педіатрія",
      "Підліткова терапія",
      "Терапія"
    ]

    education
    |> cast(attrs, education_fields)
    |> validate_required(required_fields)
    |> validate_inclusion(:degree, available_degrees)
    |> validate_inclusion(:speciality, available_specialities)
  end

  defp certificate_changeset(certificate, attrs) do
    certificate_fields = ~W(
      name
      number
      degree
      issue_date
      issued_by
      start_date
      finish_date
    )

    required_fields = [
      :name,
      :number,
      :degree,
      :issue_date,
      :issued_by
    ]

    certificate
    |> cast(attrs, certificate_fields)
    |> validate_required(required_fields)
  end

  defp medical_license_changeset(licence, attrs) do
    medical_license_fields = ~W(
      category
      type
      issued_by
      order_no
      issued_date
      expiry_date
    )

    required_fields = [
      :category,
      :type,
      :issued_by,
      :order_no,
      :issued_date,
      :expiry_date
    ]

    available_categories = [
      "Атестація на визначення знань і практичних навиків"
    ]

    available_types = [
      "Диплом"
    ]

    licence
    |> cast(attrs, medical_license_fields)
    |> validate_required(required_fields)
    |> validate_inclusion(:category, available_categories)
    |> validate_inclusion(:type, available_types)
  end
end
