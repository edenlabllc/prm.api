defmodule PRM.Entities do
  @moduledoc """
  The boundary for the Entities system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Entities.LegalEntity
  alias PRM.Entities.MSP
  alias PRM.Entities.Division

  @fields_legal_entity ~W(
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
    created_by
    updated_by
  )

  @fields_required_legal_entity ~W(
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
    created_by
    updated_by
  )a

  @fields_msp ~W(
    legal_entity_id
    accreditation
    license
  )a

  @fields_division ~W(
    legal_entity_id
    external_id
    name
    type
    mountain_group
    address
    phones
    email
  )

  @fields_required_division ~W(
    legal_entity_id
    name
    type
    address
    phones
    email
  )a

  def list_legal_entities do
    Repo.all(LegalEntity)
  end

  def get_legal_entity!(id), do: Repo.get!(LegalEntity, id)
  def get_legal_entity_with_msp!(id) do
    id
    |> get_legal_entity!()
    |> Map.put(:msp, get_msp_by_legal_entity_id!(id))
  end

  def create_legal_entity(attrs \\ %{}) do
    %LegalEntity{}
    |> legal_entity_changeset(attrs)
    |> Repo.insert()
    |> create_msp(attrs)
  end

  def update_legal_entity(%LegalEntity{} = legal_entity, attrs) do
    legal_entity
    |> legal_entity_changeset(attrs)
    |> Repo.update()
    |> update_msp(attrs)
  end

  def change_legal_entity(%LegalEntity{} = legal_entity) do
    legal_entity_changeset(legal_entity, %{})
  end

  defp legal_entity_changeset(%LegalEntity{} = legal_entity, attrs) do
    legal_entity
    |> cast(attrs, @fields_legal_entity)
    |> validate_required(@fields_required_legal_entity)
    |> validate_length(:edrpou, is: 8)
    |> validate_inclusion(:type, ["MSP", "MIS"])
    |> validate_inclusion(:status, ["VERIFIED", "NOT_VERIFIED"])
    |> validate_inclusion(:owner_property_type, ["STATE", "PRIVATE"])
  end


  # MSP


  def list_medical_service_providers do
    Repo.all(MSP)
  end

  def get_msp_by_legal_entity_id!(id) do
    Repo.one! from m in MSP,
      where: [legal_entity_id: ^id]
  end

  def create_msp({:ok, %LegalEntity{id: id} = legal_entity}, %{"medical_service_provider" => msp}) do
    %MSP{}
    |> msp_changeset(Map.put(msp, "legal_entity_id", id))
    |> Repo.insert()
    |> put_msp_to_legal_entity(legal_entity)
  end
  def create_msp(legal_entity, _attr), do: legal_entity

  def update_msp({:ok, %LegalEntity{id: id} = legal_entity}, %{"medical_service_provider" => msp}) do
    id
    |> get_msp_by_legal_entity_id!()
    |> msp_changeset(msp)
    |> Repo.update()
    |> put_msp_to_legal_entity(legal_entity)
  end
  def update_msp(legal_entity, _attr), do: legal_entity

  defp put_msp_to_legal_entity({:ok, %MSP{} = msp}, %LegalEntity{} = legal_entity) do
    {:ok, Map.put(legal_entity, :msp, msp)}
  end
  defp put_msp_to_legal_entity(msp, _), do: msp

  defp msp_changeset(%MSP{} = msp, attrs) do
    msp
    |> cast(attrs, @fields_msp)
    |> validate_required(@fields_msp)
  end


  # Divisions


  def list_divisions do
    Repo.all(Division)
  end

  def get_division!(id), do: Repo.get!(Division, id)

  def create_division(attrs) do
    %Division{}
    |> division_changeset(attrs)
    |> Repo.insert()
  end

  def create_division({:error, _} = err, _), do: err
  def create_division({:ok, %LegalEntity{id: id}}, attrs) when is_map(attrs) do
    attrs
    |> Map.put("legal_entity_id", id)
    |> create_division()
  end

  def update_division(%Division{} = division, attrs) do
    division
    |> division_changeset(attrs)
    |> Repo.update()
  end

  def change_division(%Division{} = division) do
    division_changeset(division, %{})
  end

  defp division_changeset(%Division{} = division, attrs) do
    division
    |> cast(attrs, @fields_division)
    |> validate_required(@fields_division)
  end
end
