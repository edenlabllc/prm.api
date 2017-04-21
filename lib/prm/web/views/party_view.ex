defmodule PRM.Web.PartyView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.PartyView

  def render("index.json", %{parties: parties}) do
    render_many(parties, PartyView, "party.json")
  end

  def render("show.json", %{party: party}) do
    render_one(party, PartyView, "party.json")
  end

  def render("party.json", %{party: party}) do
    %{
      id: party.id,
      first_name: party.first_name,
      second_name: party.second_name,
      last_name: party.last_name,
      birth_date: party.birth_date,
      gender: party.gender,
      tax_id: party.tax_id,
      documents: party.documents,
      phones: party.phones,
      inserted_by: party.inserted_by,
      updated_by: party.updated_by
    }
  end
end
