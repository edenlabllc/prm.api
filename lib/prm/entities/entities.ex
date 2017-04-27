defmodule PRM.Entities do
  @moduledoc """
  The boundary for the Entities system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Entities.LegalEntity
  alias PRM.Entities.LegalEntitySearch
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
    inserted_by
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
    inserted_by
    updated_by
  )a

  @fields_division ~W(
    legal_entity_id
    external_id
    name
    type
    mountain_group
    addresses
    phones
    email
  )

  @fields_required_division ~W(
    legal_entity_id
    name
    type
    addresses
    phones
    email
  )a

  def list_legal_entities(params) do
    %LegalEntitySearch{}
    |> legal_entity_changeset(params)
    |> search_legal_entities(params)
  end

  defp search_legal_entities(%Ecto.Changeset{valid?: true, changes: changes}, params) do
    limit =
      params
      |> Map.get("limit", Confex.get(:prm, :legal_entities_per_page))
      |> to_integer()

    cursors = %Ecto.Paging.Cursors{
      starting_after: Map.get(params, "starting_after"),
      ending_before: Map.get(params, "ending_before")
    }

    LegalEntity
    |> get_search_query(changes)
    |> Repo.page(%Ecto.Paging{limit: limit, cursors: cursors})
    |> preload_msp
  end

  defp search_legal_entities(%Ecto.Changeset{valid?: false} = changeset, _params) do
    {:error, changeset}
  end

  def get_legal_entity!(id) do
    LegalEntity
    |> Repo.get!(id)
    |> Repo.preload(:medical_service_provider)
  end

  def create_legal_entity(attrs \\ %{}) do
    %LegalEntity{}
    |> legal_entity_changeset(attrs)
    |> Repo.insert()
    |> preload_msp()
  end

  def update_legal_entity(%LegalEntity{} = legal_entity, attrs) do
    legal_entity
    |> legal_entity_changeset(attrs)
    |> Repo.update()
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
      edrpou
      type
      status
      owner_property
    )

    cast(legal_entity, attrs, fields)
  end

  defp legal_entity_changeset(%LegalEntity{} = legal_entity, attrs) do
    legal_entity
    |> cast(attrs, @fields_legal_entity)
    |> cast_assoc(:medical_service_provider)
    |> validate_required(@fields_required_legal_entity)
    |> validate_msp_required()
    |> unique_constraint(:edrpou)
  end

  defp validate_msp_required(%Ecto.Changeset{changes: %{type: "MSP"}} = changeset) do
    validate_required(changeset, [:medical_service_provider])
  end
  defp validate_msp_required(changeset), do: changeset

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

    Division
    |> get_search_query(changes)
    |> Repo.page(%Ecto.Paging{limit: limit, cursors: cursors})
  end

  defp search_divisions(%Ecto.Changeset{valid?: false} = changeset, _params) do
    {:error, changeset}
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
    |> validate_required(@fields_required_division)
  end

  defp division_search_changeset(attrs) do
    %DivisionSearch{}
    |> cast(attrs, [:type, :legal_entity_id])
  end

  defp get_search_query(entity, changes) when map_size(changes) > 0 do
    params = Map.to_list(changes)

    from e in entity,
      where: ^params
  end
  defp get_search_query(entity, _changes), do: from e in entity

  def to_integer(value) when is_binary(value), do: String.to_integer(value)
  def to_integer(value), do: value
end
