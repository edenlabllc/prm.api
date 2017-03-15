defmodule PRM.MSPAPI do
  @moduledoc """
  The boundary for the MSPAPI system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.MSP

  def list_msps do
    Repo.all(MSP)
  end

  def get_msp!(id), do: Repo.get!(MSP, id)

  def create_msp(attrs \\ %{}) do
    %MSP{}
    |> msp_changeset(attrs)
    |> Repo.insert()
  end

  def update_msp(%MSP{} = msp, attrs) do
    msp
    |> msp_changeset(attrs)
    |> Repo.update()
  end

  def delete_msp(%MSP{} = msp) do
    Repo.delete(msp)
  end

  def change_msp(%MSP{} = msp) do
    msp_changeset(msp, %{})
  end

  defp msp_changeset(%MSP{} = msp, attrs) do
    fields = ~W(
      name
      short_name
      type
      edrpou
      services
      licenses
      accreditations
      addresses
      phones
      emails
      created_by
      updated_by
      active
    )

    msp
    |> cast(attrs, fields)
  end
end
