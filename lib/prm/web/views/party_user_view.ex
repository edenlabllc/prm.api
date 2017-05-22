defmodule PRM.Web.PartyUserView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.PartyUserView

  def render("index.json", %{party_users: party_users}) do
    render_many(party_users, PartyUserView, "party_user.json")
  end

  def render("show.json", %{party_user: party_user}) do
    render_one(party_user, PartyUserView, "party_user.json")
  end

  def render("party_user.json", %{party_user: party_user}) do
    %{
      id: party_user.id,
      user_id: party_user.user_id,
      party_id: party_user.party_id,
    }
  end
end
