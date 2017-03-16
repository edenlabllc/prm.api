defmodule PRM.DoctorSearch do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "doctor_search" do
    field :first_name, :string
    field :last_name, :string
    field :second_name, :string
    field :speciality, :string
    field :region, :string
    field :area, :string
    field :msp_id, :string
    field :is_active, :boolean, default: true
  end

  def validate(attrs \\ %{}) do
    fields = ~W(
      first_name
      last_name
      second_name
      speciality
      region
      area
    )a

    %PRM.DoctorSearch{}
    |> cast(attrs, fields)
    |> validate_any_is_present(fields)
  end

  def validate_any_is_present(changeset, fields) do
    if Enum.any?(fields, &present?(changeset, &1)) do
      changeset
    else
      add_error(changeset, hd(fields), "One of these fields must be present: #{inspect fields}")
    end
  end

  defp present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end
end
