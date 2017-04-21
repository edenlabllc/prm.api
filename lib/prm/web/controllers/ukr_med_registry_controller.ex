defmodule PRM.Web.UkrMedRegistryController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.Registries
  alias PRM.Registries.UkrMedRegistry

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    ukr_med_registries = Registries.list_ukr_med_registries()
    render(conn, "index.json", ukr_med_registries: ukr_med_registries)
  end

  def create(conn, ukr_med_params) do
    with {:ok, %UkrMedRegistry{} = ukr_med_registry} <- Registries.create_ukr_med(ukr_med_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ukr_med_registry_path(conn, :show, ukr_med_registry))
      |> render("show.json", ukr_med_registry: ukr_med_registry)
    end
  end

  def show(conn, %{"id" => id}) do
    ukr_med_registry = Registries.get_ukr_med!(id)
    render(conn, "show.json", ukr_med_registry: ukr_med_registry)
  end

  def update(conn, %{"id" => id} = ukr_med_params) do
    ukr_med_registry = Registries.get_ukr_med!(id)

    with {:ok, %UkrMedRegistry{} = ukr_med_registry} <- Registries.update_ukr_med(ukr_med_registry, ukr_med_params) do
      render(conn, "show.json", ukr_med_registry: ukr_med_registry)
    end
  end
end
