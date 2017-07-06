defmodule PRM.Repo.Migrations.AddMisVerifiedToLegalEntity do
  use Ecto.Migration
  import Ecto.Query
  alias PRM.Entities.LegalEntity

  def change do
    # Set default while we're migrating value from the status field
    alter table(:legal_entities) do
      add :mis_verified, :string, null: false, default: LegalEntity.mis_verified(:not_verified)
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
