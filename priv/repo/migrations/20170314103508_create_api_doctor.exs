defmodule PRM.Repo.Migrations.CreatePRM.API.Doctor do
  use Ecto.Migration

  def change do
    create table(:api_doctors) do
      add :thing, :string

      timestamps()
    end

  end
end
