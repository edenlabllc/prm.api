defmodule PRM.Registries.UkrMedRegistrySearch do
  @moduledoc false

  use Ecto.Schema

  schema "ukr_med_registries_search" do
    field :edrpou, :string
  end
end
