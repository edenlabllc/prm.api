defmodule PRM.Registries do
  @moduledoc """
  The boundary for the Registries system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.Registries.UkrMedRegistry

  def list_ukr_med_registries do
    Repo.all(UkrMedRegistry)
  end

  def get_ukr_med!(id), do: Repo.get!(UkrMedRegistry, id)

  def create_ukr_med(attrs \\ %{}) do
    %UkrMedRegistry{}
    |> ukr_med_changeset(attrs)
    |> Repo.insert()
  end

  def update_ukr_med(%UkrMedRegistry{} = ukr_med_registry, attrs) do
    ukr_med_registry
    |> ukr_med_changeset(attrs)
    |> Repo.update()
  end

  def delete_ukr_med(%UkrMedRegistry{} = ukr_med_registry) do
    Repo.delete(ukr_med_registry)
  end

  def change_ukr_med(%UkrMedRegistry{} = ukr_med_registry) do
    ukr_med_changeset(ukr_med_registry, %{})
  end

  defp ukr_med_changeset(%UkrMedRegistry{} = ukr_med_registry, attrs) do
    fields = ~W(
      name
      edrpou
      inserted_by
      updated_by
    )

    required = ~W(
      edrpou
      inserted_by
      updated_by
    )a

    ukr_med_registry
    |> cast(attrs, fields)
    |> validate_required(required)
    |> validate_length(:edrpou, is: 8)
  end
end