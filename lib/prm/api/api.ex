defmodule Prm.API do
  @moduledoc """
  The boundary for the API system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Prm.Repo

  alias Prm.API.Doctor

  @doc """
  Returns the list of doctors.

  ## Examples

      iex> list_doctors()
      [%Doctor{}, ...]

  """
  def list_doctors do
    Repo.all(Doctor)
  end

  @doc """
  Gets a single doctor.

  Raises `Ecto.NoResultsError` if the Doctor does not exist.

  ## Examples

      iex> get_doctor!(123)
      %Doctor{}

      iex> get_doctor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_doctor!(id), do: Repo.get!(Doctor, id)

  @doc """
  Creates a doctor.

  ## Examples

      iex> create_doctor(doctor, %{field: value})
      {:ok, %Doctor{}}

      iex> create_doctor(doctor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_doctor(attrs \\ %{}) do
    %Doctor{}
    |> doctor_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a doctor.

  ## Examples

      iex> update_doctor(doctor, %{field: new_value})
      {:ok, %Doctor{}}

      iex> update_doctor(doctor, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_doctor(%Doctor{} = doctor, attrs) do
    doctor
    |> doctor_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Doctor.

  ## Examples

      iex> delete_doctor(doctor)
      {:ok, %Doctor{}}

      iex> delete_doctor(doctor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_doctor(%Doctor{} = doctor) do
    Repo.delete(doctor)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking doctor changes.

  ## Examples

      iex> change_doctor(doctor)
      %Ecto.Changeset{source: %Doctor{}}

  """
  def change_doctor(%Doctor{} = doctor) do
    doctor_changeset(doctor, %{})
  end

  defp doctor_changeset(%Doctor{} = doctor, attrs) do
    doctor
    |> cast(attrs, [:thing])
    |> validate_required([:thing])
  end
end
