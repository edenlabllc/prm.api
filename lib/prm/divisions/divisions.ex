defmodule PRM.Divisions do
  @moduledoc """
  The boundary for the Divisions system.
  """
  use PRM.Search

  import Ecto.{Query, Changeset}, warn: false
  import PRM.Entities, only: [convert_comma_params_to_where_in_clause: 3]

  alias PRM.Repo
  alias PRM.Entities.LegalEntity
  alias PRM.Divisions.Division
  alias PRM.Divisions.DivisionSearch

  def list_divisions(params) do
    %DivisionSearch{}
    |> division_changeset(params)
    |> search(params, Division, Confex.get(:prm, :divisions_per_page))
  end

  def get_search_query(Division = entity, %{ids: _} = changes) do
    super(entity, convert_comma_params_to_where_in_clause(changes, :ids, :id))
  end

  def get_search_query(Division = division, changes) do
    params =
      changes
      |> Map.drop([:name])
      |> Map.to_list()

    division
    |> select([d], d)
    |> query_name(Map.get(changes, :name))
    |> where(^params)
  end

  def query_name(query, nil), do: query
  def query_name(query, name) do
    query |> where([d], ilike(d.name, ^"%#{name}%"))
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

  def set_divisions_mountain_group(attrs) do
    attrs
    |> mountain_group_changeset()
    |> update_divisions_mountain_group()
  end

  def mountain_group_changeset(attrs) do
    data  = %{}
    types = %{mountain_group: :string, settlement_id: Ecto.UUID}

    {data, types}
    |> cast(attrs, Map.keys(types))
    |> validate_required(Map.keys(types))
  end

  def update_divisions_mountain_group(%Ecto.Changeset{valid?: true} = ch) do
    settlement_id = get_change(ch, :settlement_id)
    mountain_group = get_change(ch, :mountain_group)
    addresses = [%{settlement_id: settlement_id}]

    query =
      from d in Division,
      where: d.mountain_group != ^mountain_group,
      where: fragment("? @> ?", d.addresses, ^addresses)

    Repo.update_all(query, set: [mountain_group: mountain_group])
  end
  def update_divisions_mountain_group(ch), do: ch

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
    fields = ~W(
      ids
      name
      legal_entity_id
      type
    )
    cast(division, attrs, fields)
  end

end
