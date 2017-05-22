defmodule PRM.Parties.PartyUser do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "parties_party_users" do
    field :user_id, Ecto.UUID

    belongs_to :party, PRM.Parties.Party, type: Ecto.UUID

    timestamps()
  end
end
