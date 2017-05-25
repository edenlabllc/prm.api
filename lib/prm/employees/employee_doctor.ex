defmodule PRM.Employees.EmployeeDoctor do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder, except: [:__meta__, :employee, :employee_id, :id, :inserted_at, :updated_at]}

  schema "employee_doctors" do

    embeds_one :science_degree, ScienceDegree, on_replace: :delete, primary_key: false do
      field :country, :string
      field :city, :string
      field :degree, :string
      field :institution_name, :string
      field :diploma_number, :string
      field :speciality, :string
      field :issued_date, :date
    end

    embeds_many :qualifications, Qualification, on_replace: :delete, primary_key: false do
      field :type, :string
      field :institution_name, :string
      field :speciality, :string
      field :certificate_number, :string
      field :issued_date, :date
    end

    embeds_many :educations, Education, on_replace: :delete, primary_key: false do
      field :country, :string
      field :city, :string
      field :degree, :string
      field :institution_name, :string
      field :diploma_number, :string
      field :speciality, :string
      field :issued_date, :date
    end

    embeds_many :specialities, Speciality, on_replace: :delete, primary_key: false do
      field :speciality, :string
      field :speciality_officio, :boolean
      field :level, :string
      field :qualification_type, :string
      field :attestation_name, :string
      field :attestation_date, :date
      field :valid_to_date, :date
      field :certificate_number, :string
    end

    belongs_to :employee, PRM.Employees.Employee, type: Ecto.UUID

    timestamps()
  end

  def changeset(%PRM.Employees.EmployeeDoctor{} = employee_doctor, attrs) do
    employee_doctor
    |> cast(attrs, [])
    |> validate_required([:educations, :specialities])
    |> cast_embed(:science_degree, with: &changeset_science_degree/2)
    |> cast_embed(:educations, with: &changeset_educations/2)
    |> cast_embed(:specialities, with: &changeset_specialities/2)
    |> cast_embed(:qualifications, with: &changeset_qualifications/2)
  end

  def changeset_science_degree(%PRM.Employees.EmployeeDoctor.ScienceDegree{} = schema, attrs) do
    fields = ~W(
      country
      city
      degree
      institution_name
      diploma_number
      speciality
      issued_date
    )a

    schema
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

  def changeset_educations(%PRM.Employees.EmployeeDoctor.Education{} = schema, attrs) do
    fields = ~W(
      country
      city
      degree
      institution_name
      diploma_number
      speciality
      issued_date
    )a

    schema
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

  def changeset_specialities(%PRM.Employees.EmployeeDoctor.Speciality{} = schema, attrs) do
    fields = ~W(
      speciality
      speciality_officio
      level
      qualification_type
      attestation_name
      attestation_date
      valid_to_date
      certificate_number
    )a

    schema
    |> cast(attrs, fields)
    |> validate_required(fields)
  end

  def changeset_qualifications(%PRM.Employees.EmployeeDoctor.Qualification{} = schema, attrs) do
    fields = ~W(
      type
      institution_name
      speciality
      certificate_number
      issued_date
    )a

    schema
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
