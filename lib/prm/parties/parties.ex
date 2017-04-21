defmodule PRM.Parties do
  @moduledoc """
  The boundary for the Parties system.
  """

  import Ecto.{Query, Changeset}, warn: false

  alias PRM.Repo
  alias PRM.Parties.Party
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

  def list_parties do
    Repo.all(Party)
  end

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

  defp party_changeset(%Party{} = party, attrs) do
    party
    |> cast(attrs, @fields_party)
    |> cast_embed(:documents, with: &Document.changeset/2)
    |> cast_embed(:phones, with: &Phone.changeset/2)
    |> validate_required(@fields_required_party)
  end
end
