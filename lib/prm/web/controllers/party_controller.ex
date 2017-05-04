defmodule PRM.Web.PartyController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.Parties
  alias PRM.Parties.Party

  action_fallback PRM.Web.FallbackController

  def index(conn, params) do
    with {parties, %Ecto.Paging{} = paging} <- Parties.list_parties(params) do
      render(conn, "index.json", parties: parties, paging: paging)
    end
  end

  def create(conn, %{"party" => party_params}) do
    with {:ok, %Party{} = party} <- Parties.create_party(party_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", party_path(conn, :show, party))
      |> render("show.json", party: party)
    end
  end

  def show(conn, %{"id" => id}) do
    party = Parties.get_party!(id)
    render(conn, "show.json", party: party)
  end

  def update(conn, %{"id" => id, "party" => party_params}) do
    party = Parties.get_party!(id)

    with {:ok, %Party{} = party} <- Parties.update_party(party, party_params) do
      render(conn, "show.json", party: party)
    end
  end
end
