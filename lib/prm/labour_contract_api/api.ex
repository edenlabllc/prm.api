defmodule PRM.LabourContractAPI do
  @moduledoc """
  The boundary for the LabourContractAPI system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.LabourContract

  def list_labour_contracts do
    Repo.all(LabourContract)
  end

  def get_labour_contract!(id), do: Repo.get!(LabourContract, id)

  def create_labour_contract(attrs \\ %{}) do
    %LabourContract{}
    |> labour_contract_changeset(attrs)
    |> Repo.insert()
  end

  def update_labour_contract(%LabourContract{} = labour_contract, attrs) do
    labour_contract
    |> labour_contract_changeset(attrs)
    |> Repo.update()
  end

  def delete_labour_contract(%LabourContract{} = labour_contract) do
    Repo.delete(labour_contract)
  end

  def change_labour_contract(%LabourContract{} = labour_contract) do
    labour_contract_changeset(labour_contract, %{})
  end

  defp labour_contract_changeset(%LabourContract{} = labour_contract, attrs) do
    fields = ~W(
      title
      specialty
      start_date
      end_date
      active
      created_by
      updated_by
      doctor_id
      msp_id
    )

    labour_contract
    |> cast(attrs, fields)
  end
end
