defmodule PRM.Web.PartyUserController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.Parties
  alias PRM.Parties.PartyUser

  action_fallback PRM.Web.FallbackController

  def index(conn, params) do
    with {party_users, %Ecto.Paging{} = paging} <- Parties.list_party_users(params) do
      render(conn, "index.json", party_users: party_users, paging: paging)
    end
  end

  def create(conn, party_user_params) do
    with {:ok, %PartyUser{} = party_user} <- Parties.create_party_user(party_user_params, get_consumer_id(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", party_user_path(conn, :show, party_user))
      |> render("show.json", party_user: party_user)
    end
  end

  def show(conn, %{"id" => id}) do
    party_user = Parties.get_party_user!(id)
    render(conn, "show.json", party_user: party_user)
  end

  def update(conn, %{"id" => id} = party_user_params) do
    party_user = Parties.get_party_user!(id)

    with {:ok, %PartyUser{} = party_user} <- Parties.update_party_user(
      party_user, party_user_params, get_consumer_id(conn)) do

      render(conn, "show.json", party_user: party_user)
    end
  end
end
