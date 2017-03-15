defmodule PRM.Web.LabourContractController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.LabourContractAPI
  alias PRM.LabourContract

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    labour_contracts = LabourContractAPI.list_labour_contracts()
    render(conn, "index.json", labour_contracts: labour_contracts)
  end

  def create(conn, %{"labour_contract" => labour_contract_params}) do
    result = LabourContractAPI.create_labour_contract(labour_contract_params)

    with {:ok, %LabourContract{} = labour_contract} <- result do
      conn
      |> put_status(:created)
      |> put_resp_header("location", labour_contract_path(conn, :show, labour_contract))
      |> render("show.json", labour_contract: labour_contract)
    end
  end

  def show(conn, %{"id" => id}) do
    labour_contract = LabourContractAPI.get_labour_contract!(id)
    render(conn, "show.json", labour_contract: labour_contract)
  end

  def update(conn, %{"id" => id, "labour_contract" => labour_contract_params}) do
    labour_contract = LabourContractAPI.get_labour_contract!(id)
    result = LabourContractAPI.update_labour_contract(labour_contract, labour_contract_params)
    with {:ok, %LabourContract{} = labour_contract} <- result do
      render(conn, "show.json", labour_contract: labour_contract)
    end
  end

  def delete(conn, %{"id" => id}) do
    labour_contract = LabourContractAPI.get_labour_contract!(id)
    with {:ok, %LabourContract{}} <- LabourContractAPI.delete_labour_contract(labour_contract) do
      send_resp(conn, :no_content, "")
    end
  end
end
