defmodule PRM.API do
  @moduledoc """
  The boundary for the API system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.API.Doctor

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

  defp doctor_changeset(%Doctor{} = doctor, attrs) do
    doctor
    |> cast(attrs, [:thing])
    |> validate_required([:thing])
  end
end