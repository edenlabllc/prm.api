defmodule PRM.Repo.Migrations.AddMisVerifiedToLegalEntity do
  use Ecto.Migration
  import Ecto.Query
  alias PRM.Entities.LegalEntity

  def change do
    alter table(:legal_entities) do
      add :mis_verified, :string, null: false
    end
    flush()

    LegalEntity
    |> update([le], set: [mis_verified: le.status])
    |> PRM.Repo.update_all([])

    active_status = LegalEntity.status(:active)
    LegalEntity
    |> update([le], set: [status: ^active_status])
    |> PRM.Repo.update_all([])
  end
end
