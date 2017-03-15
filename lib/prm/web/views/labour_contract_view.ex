defmodule PRM.Web.LabourContractView do
  @moduledoc false

  use PRM.Web, :view

  alias PRM.Web.LabourContractView

  def render("index.json", %{labour_contracts: labour_contracts}) do
    render_many(labour_contracts, LabourContractView, "labour_contract.json")
  end

  def render("show.json", %{labour_contract: labour_contract}) do
    render_one(labour_contract, LabourContractView, "labour_contract.json")
  end

  def render("labour_contract.json", %{labour_contract: labour_contract}) do
    %{
      id: labour_contract.id,
      title: labour_contract.title,
      specialty: labour_contract.specialty,
      start_date: labour_contract.start_date,
      end_date: labour_contract.end_date,
      active: labour_contract.active,
      created_by: labour_contract.created_by,
      updated_by: labour_contract.updated_by,
      doctor_id: labour_contract.doctor_id,
      msp_id: labour_contract.msp_id
    }
  end
end
