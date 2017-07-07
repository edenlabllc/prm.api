defmodule PRM.Repo do
  @moduledoc false
  use Ecto.Repo, otp_app: :prm
  use Ecto.Paging.Repo
  use EctoTrail
  import Ecto.Query
  alias PRM.Repo

  def bulk_update(query, data, bulk_size \\ 50) do
    limit = bulk_size + 1
    _bulk_update({limit, nil}, query, data, limit)
  end

  defp _bulk_update({updated_limit, nil}, _query, _data, limit) when updated_limit < limit, do: :ok

  defp _bulk_update(_updated_limit, query, data, limit) do
    query
    |> get_ids_for_update(limit)
    |> update_by_ids(query, data)
    |> _bulk_update(query, data, limit)
  end

  defp get_ids_for_update(query, limit) do
    query
    |> select([:id])
    |> limit(^limit)
    |> Repo.all()
    |> Enum.map(fn(%{id: id}) -> id end)
  end

  defp update_by_ids([], _query, _data), do: {0, nil}
  defp update_by_ids(update_ids, query, data) do
    query
    |> where([e], e.id in ^update_ids)
    |> Repo.update_all(set: data)
  end
end
