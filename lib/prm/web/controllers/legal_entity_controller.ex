defmodule PRM.Web.LegalEntityController do
  use PRM.Web, :controller

  alias PRM.Entities
  alias PRM.Entities.LegalEntity

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    legal_entities = Entities.list_legal_entities()
    render(conn, "index.json", legal_entities: legal_entities)
  end

  def create(conn, %{"legal_entity" => legal_entity_params}) do
    with {:ok, %LegalEntity{} = legal_entity} <- Entities.create_legal_entity(legal_entity_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", legal_entity_path(conn, :show, legal_entity))
      |> render("show.json", legal_entity: legal_entity)
    end
  end

  def show(conn, %{"id" => id}) do
    legal_entity = Entities.get_legal_entity!(id)
    render(conn, "show.json", legal_entity: legal_entity)
  end

  def update(conn, %{"id" => id, "legal_entity" => legal_entity_params}) do
    legal_entity = Entities.get_legal_entity!(id)

    with {:ok, %LegalEntity{} = legal_entity} <- Entities.update_legal_entity(legal_entity, legal_entity_params) do
      render(conn, "show.json", legal_entity: legal_entity)
    end
  end

  def delete(conn, %{"id" => id}) do
    legal_entity = Entities.get_legal_entity!(id)
    with {:ok, %LegalEntity{}} <- Entities.delete_legal_entity(legal_entity) do
      send_resp(conn, :no_content, "")
    end
  end
end
