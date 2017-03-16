defmodule PRM.Doctor do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "doctors" do
    field :mpi_id, :string
    field :status, :string
    field :jobs, {:array, :map}
    field :active, :boolean, default: false
    field :name, :string
    field :created_by, :string
    field :updated_by, :string

    embeds_many :education, Education do
      field :institution_name, :string
      field :certificate_number, :string
      field :degree, :string
      field :start_date, :utc_datetime
      field :finished_date, :utc_datetime
      field :speciality
    end

    embeds_many :certificates, Certificate do
      field :name, :string
      field :number, :string
      field :degree, :string
      field :issue_date, :utc_datetime
      field :issued_by, :string
      field :start_date, :utc_datetime
      field :finish_date, :utc_datetime
    end

    embeds_many :licenses, License do
      field :license_number, :string
      field :kved, {:array, :string}
      field :issued_by, :string
      field :issued_date, :utc_datetime
      field :expiry_date, :utc_datetime
    end

    timestamps(type: :utc_datetime)
  end
end
