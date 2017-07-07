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

    resources "/party", PartyController, except: [:new, :edit, :delete]
    resources "/party_users", PartyUserController, except: [:new, :edit, :delete]
    resources "/employees", EmployeeController, except: [:new, :edit, :delete]
    resources "/divisions", DivisionController, except: [:new, :edit, :delete]
    patch "/divisions/actions/set_mountain_group", DivisionController, :set_mountain_group
    resources "/legal_entities", LegalEntityController, except: [:new, :edit, :delete]
    resources "/ukr_med_registry", UkrMedRegistryController, except: [:new, :edit, :delete]

    get "/global_parameters", GlobalParameterController, :index
    put "/global_parameters", GlobalParameterController, :create_or_update
  end
end
