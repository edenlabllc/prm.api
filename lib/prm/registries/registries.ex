defmodule PRM.Registries do
  @moduledoc """
  The boundary for the Registries system.
  """

  import Ecto.{Query, Changeset}, warn: false
  import PRM.Entities, only: [to_integer: 1]

  alias PRM.Repo
  alias PRM.Registries.UkrMedRegistry

  def list_ukr_med_registries(params) do
    limit =
      params
      |> Map.get("limit", Confex.get(:prm, :divisions_per_page))
      |> to_integer()

    cursors = %Ecto.Paging.Cursors{
      starting_after: Map.get(params, "starting_after"),
      ending_before: Map.get(params, "ending_before")
    }

    params
    |> get_search_ukr_med_registries_query()
    |> Repo.page(%Ecto.Paging{limit: limit, cursors: cursors})
  end

  defp get_search_ukr_med_registries_query(%{"edrpou" => edrpou}) do
    from u in UkrMedRegistry,
      where: [edrpou: ^edrpou]
  end
  defp get_search_ukr_med_registries_query(_changes), do: from u in UkrMedRegistry

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
    |> unique_constraint(:edrpou)
  end
end
