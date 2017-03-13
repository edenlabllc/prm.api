defmodule Prm.Repo.Migrations.CreatePrm.CapitationContract do
  use Ecto.Migration

  def change do
    create table(:capitation_contracts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :msp_id, :string
      add :product_id, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :status, :string
      add :signed_at, :utc_datetime
      add :services, {:array, :map}

      timestamps()
    end

  end
end
