defmodule PRM.Declaration.Report do
  import Ecto.Query, only: [from: 2]

  alias PRM.Declaration

  def report(params) do
    query =
      from d in Declaration,
        where: d.doctor_id == ^params["doctor_id"],
        where: d.inserted_at >= ^params["start_date"],
        where: d.inserted_at <= ^params["end_date"]

    PRM.Repo.all(query)
  end
end
