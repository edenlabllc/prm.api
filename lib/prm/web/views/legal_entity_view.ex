defmodule PRM.Web.LegalEntityView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.LegalEntityView

  def render("index.json", %{legal_entities: legal_entities}) do
    render_many(legal_entities, LegalEntityView, "legal_entity.json")
  end

  def render("show.json", %{legal_entity: legal_entity}) do
    render_one(legal_entity, LegalEntityView, "legal_entity.json")
  end

  def render("legal_entity.json", %{legal_entity: %{medical_service_provider: msp} = legal_entity}) do
    legal_entity
    |> render_legal_entity()
    |> Map.put(:medical_service_provider, %{
         licenses: msp.licenses,
         accreditation: msp.accreditation,
    })
  end

  def render("legal_entity.json", %{legal_entity: legal_entity}) do
    render_legal_entity(legal_entity)
  end

  defp render_legal_entity(legal_entity) do
    %{id: legal_entity.id,
      name: legal_entity.name,
      short_name: legal_entity.short_name,
      public_name: legal_entity.public_name,
      status: legal_entity.status,
      type: legal_entity.type,
      owner_property_type: legal_entity.owner_property_type,
      legal_form: legal_entity.legal_form,
      edrpou: legal_entity.edrpou,
      kveds: legal_entity.kveds,
      addresses: legal_entity.addresses,
      phones: legal_entity.phones,
      email: legal_entity.email,
      is_active: legal_entity.is_active,
      inserted_by: legal_entity.inserted_by,
      updated_by: legal_entity.updated_by,
      created_by_mis_client_id: legal_entity.created_by_mis_client_id}
  end
end
