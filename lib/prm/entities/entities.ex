defmodule PRM.Entities do
  @moduledoc """
  The boundary for the Entities system.
  """

  use PRM.Search

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Entities.LegalEntity
  alias PRM.Entities.LegalEntitySearch

  def list_legal_entities(params) do
    %LegalEntitySearch{}
    |> legal_entity_changeset(params)
    |> search(params, LegalEntity, Confex.get(:prm, :legal_entities_per_page))
    |> preload_msp()
  end

  def get_search_query(LegalEntity = entity, %{settlement_id: settlement_id} = changes) do
    params =
      changes
      |> Map.delete(:settlement_id)
      |> Map.to_list()

    address_params = [%{settlement_id: settlement_id}]

    from e in entity,
      where: ^params,
      where: fragment("? @> ?", e.addresses, ^address_params)
  end
  def get_search_query(entity, changes), do: super(entity, changes)

  def get_legal_entity!(id) do
    LegalEntity
    |> Repo.get!(id)
    |> Repo.preload(:medical_service_provider)
  end

  def create_legal_entity(attrs, user_id) do
    %LegalEntity{}
    |> legal_entity_changeset(attrs)
    |> Repo.insert_and_log(user_id)
    |> preload_msp()
  end

  def update_legal_entity(%LegalEntity{} = legal_entity, attrs, user_id) do
    legal_entity
    |> legal_entity_changeset(attrs)
    |> Repo.update_and_log(user_id)
    |> preload_msp()
  end

  def preload_msp({legal_entities, %Ecto.Paging{} = paging}) when length(legal_entities) > 0 do
    {Repo.preload(legal_entities, :medical_service_provider), paging}
  end
  def preload_msp({:ok, legal_entity}) do
    {:ok, Repo.preload(legal_entity, :medical_service_provider)}
  end
  def preload_msp(err), do: err

  def change_legal_entity(%LegalEntity{} = legal_entity) do
    legal_entity_changeset(legal_entity, %{})
  end

  defp legal_entity_changeset(%LegalEntitySearch{} = legal_entity, attrs) do
    fields = ~W(
      id
      edrpou
      type
      status
      owner_property_type
      legal_form
      nhs_verified
      is_active
      settlement_id
      created_by_mis_client_id
      mis_verified
    )

    cast(legal_entity, attrs, fields)
  end

  defp legal_entity_changeset(%LegalEntity{} = legal_entity, attrs) do
    fields_legal_entity = ~W(
      id
      name
      short_name
      public_name
      status
      type
      owner_property_type
      legal_form
      edrpou
      kveds
      addresses
      phones
      email
      is_active
      nhs_verified
      inserted_by
      updated_by
      created_by_mis_client_id
      mis_verified
    )

    fields_required_legal_entity = ~W(
      name
      status
      type
      owner_property_type
      legal_form
      edrpou
      kveds
      addresses
      inserted_by
      updated_by
      mis_verified
    )a

    legal_entity
    |> cast(attrs, fields_legal_entity)
    |> cast_assoc(:medical_service_provider)
    |> validate_required(fields_required_legal_entity)
    |> validate_msp_required()
    |> unique_constraint(:edrpou)
  end

  defp validate_msp_required(%Ecto.Changeset{changes: %{type: "MSP"}} = changeset) do
    validate_required(changeset, [:medical_service_provider])
  end
  defp validate_msp_required(changeset), do: changeset
end
