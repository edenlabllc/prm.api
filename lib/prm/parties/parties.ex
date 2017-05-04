defmodule PRM.Parties do
  @moduledoc """
  The boundary for the Parties system.
  """
  use PRM.Search

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Parties.Party
  alias PRM.Parties.PartySearch
  alias PRM.Meta.Phone
  alias PRM.Meta.Document

  @fields_party ~W(
    first_name
    second_name
    last_name
    birth_date
    gender
    tax_id
    inserted_by
    updated_by
  )

  @fields_required_party ~W(
    first_name
    last_name
    birth_date
    gender
    tax_id
  )a

  def list_parties(params) do
    %PartySearch{}
    |> party_changeset(params)
    |> search(params, Party, 50)
  end

  def get_search_query(entity, %{phone_number: number} = changes) do
    params =
      changes
      |> Map.delete(:phone_number)
      |> Map.to_list()

    phone_number = [%{"number" => number}]

    from e in entity,
      where: ^params,
      where: fragment("? @> ?", e.phones, ^phone_number)
  end

  def get_search_query(entity, changes) when map_size(changes) > 0 do
    params = Map.to_list(changes)

    from e in entity,
      where: ^params
  end

  def get_search_query(entity, _changes), do: from e in entity

  def get_party!(id), do: Repo.get!(Party, id)

  def create_party(attrs \\ %{}) do
    %Party{}
    |> party_changeset(attrs)
    |> Repo.insert()
  end

  def update_party(%Party{} = party, attrs) do
    party
    |> party_changeset(attrs)
    |> Repo.update()
  end

  def change_party(%Party{} = party) do
    party_changeset(party, %{})
  end

  defp party_changeset(%PartySearch{} = party, attrs) do
    fields =  ~W(
      first_name
      second_name
      last_name
      birth_date
      tax_id
      phone_number
    )
    cast(party, attrs, fields)
  end

  defp party_changeset(%Party{} = party, attrs) do
    party
    |> cast(attrs, @fields_party)
    |> cast_embed(:documents, with: &Document.changeset/2)
    |> cast_embed(:phones, with: &Phone.changeset/2)
    |> validate_required(@fields_required_party)
  end
end
