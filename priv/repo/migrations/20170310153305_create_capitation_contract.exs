defmodule Prm.Repo.Migrations.CreatePrm.CapitationContract do
  use Ecto.Migration

  def change do
    create table(:capitation_contracts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :msp_id, references(:msps), null: false
      add :product_id, references(:products), null: false
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :status, :string
      add :signed_at, :utc_datetime
      add :services, {:array, :map}

      timestamps(type: :utc_datetime)
    end
  end
end
