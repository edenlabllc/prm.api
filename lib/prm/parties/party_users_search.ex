defmodule PRM.Parties.PartyUsersSearch do
  @moduledoc false

  use Ecto.Schema

  schema "party_search" do
    field :user_id, Ecto.UUID
    field :party_id, Ecto.UUID
  end
end
