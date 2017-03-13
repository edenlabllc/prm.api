defmodule Prm.Repo.Migrations.CreatePrm.MSP do
  use Ecto.Migration

  def change do
    create table(:msps, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :short_name, :string
      add :type, :string
      add :edrpou, :string
      add :services, {:array, :map}
      add :licenses, :map
      add :accreditations, :map
      add :addresses, {:array, :map}
      add :phones, {:array, :map}
      add :emails, {:array, :map}
      add :created_by, :string
      add :updated_by, :string
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
