defmodule PRM.Entities do
  @moduledoc """
  The boundary for the Entities system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Entities.LegalEntity
  alias PRM.Entities.MSP
  alias PRM.Entities.Division
  alias PRM.Entities.DivisionSearch

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
    |> unique_constraint(:edrpou)
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

  def list_divisions(params) do
    params
    |> division_search_changeset()
    |> search_divisions(params)
  end

  defp search_divisions(%Ecto.Changeset{valid?: true, changes: changes}, params) do
    limit =
      params
      |> Map.get("limit", Confex.get(:prm, :divisions_per_page))
      |> to_integer()

    cursors = %Ecto.Paging.Cursors{
      starting_after: Map.get(params, "starting_after"),
      ending_before: Map.get(params, "ending_before")
    }

    changes
    |> get_search_divisions_query()
    |> Repo.page(%Ecto.Paging{limit: limit, cursors: cursors})
  end

  defp search_divisions(%Ecto.Changeset{valid?: false} = changeset, _params) do
    {:error, changeset}
  end

  defp get_search_divisions_query(changes) when map_size(changes) > 0 do
    params = Map.to_list(changes)

    from d in Division,
      where: ^params
  end
  defp get_search_divisions_query(_changes), do: from d in Division

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
    |> validate_required(@fields_required_division)
    |> validate_inclusion(:type, ["clinic", "ambulant_clinic", "fap"])
  end

  defp division_search_changeset(attrs) do
    %DivisionSearch{}
    |> cast(attrs, [:type, :legal_entity_id])
    |> validate_inclusion(:type, ["clinic", "ambulant_clinic", "fap"])
  end

  def to_integer(value) when is_binary(value), do: String.to_integer(value)
  def to_integer(value), do: value
end
