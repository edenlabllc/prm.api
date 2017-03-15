defmodule PRM.Web.Router do
  @moduledoc """
  API HTTP routes
  """
  use PRM.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :put_secure_browser_headers
  end

  scope "/api", PRM.Web do
    pipe_through :api # Use the default browser stack

    resources "/doctors", DoctorController
    resources "/msps", MSPController
    resources "/labour_contracts", LabourContractController
  end
end
