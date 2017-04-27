defmodule PRM.Repo.Migrations.RenameDivisionsAddressToAddresses do
  use Ecto.Migration

  def change do
    rename table(:divisions), :address, to: :addresses
  end
end
