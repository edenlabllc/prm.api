defmodule PRM.Repo.Migrations.RemoveDictionaries do
  use Ecto.Migration

  def change do
    drop table(:dictionaries)
  end
end
