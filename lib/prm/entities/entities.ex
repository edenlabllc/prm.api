defmodule PRM.Entities do
  @moduledoc """
  The boundary for the Entities system.
  """

  use PRM.Search

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Entities.LegalEntity
  alias PRM.Entities.LegalEntitySearch
  alias PRM.Entities.Division
  alias PRM.Entities.DivisionSearch

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
      name
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

    legal_entity
    |> cast(attrs, fields)
    |> set_like_attributes([:name])
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

  # Divisions

  def list_divisions(params) do
    %DivisionSearch{}
    |> division_changeset(params)
    |> search(params, Division, Confex.get(:prm, :divisions_per_page))
  end

  def get_division!(id), do: Repo.get!(Division, id)

  def create_division({:error, _} = err, _), do: err

  def create_division(attrs, user_id) do
    %Division{}
    |> division_changeset(attrs)
    |> Repo.insert_and_log(user_id)
  end

  def create_division({:ok, %LegalEntity{id: id}}, attrs, user_id) when is_map(attrs) do
    attrs
    |> Map.put("legal_entity_id", id)
    |> create_division(user_id)
  end

  def update_division(%Division{} = division, attrs, user_id) do
    division
    |> division_changeset(attrs)
    |> Repo.update_and_log(user_id)
  end

  def change_division(%Division{} = division) do
    division_changeset(division, %{})
  end

  defp division_changeset(%Division{} = division, %{"location" => %{"longitude" => lng, "latitude" => lat}} = attrs) do
    division_changeset(division, Map.put(attrs, "location", %Geo.Point{coordinates: {lng, lat}}))
  end

  defp division_changeset(%Division{} = division, attrs) do
    fields_division = ~W(
      legal_entity_id
      external_id
      name
      type
      mountain_group
      addresses
      phones
      email
      status
      is_active
      location
    )

    fields_required_division = ~W(
      legal_entity_id
      name
      type
      addresses
      phones
      status
      email
    )a

    division
    |> cast(attrs, fields_division)
    |> validate_required(fields_required_division)
    |> foreign_key_constraint(:legal_entity_id)
  end

  defp division_changeset(%DivisionSearch{} = division, attrs) do
    division
    |> cast(attrs, [:name, :type, :legal_entity_id])
    |> set_like_attributes([:name])
  end
end
