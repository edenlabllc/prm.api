defmodule PRM.Declaration.Report do
  import Ecto.Query, only: [from: 2]

  alias PRM.Declaration

  def report(params) do
    #       SELECT days.day,
    #              count(declarations.id) as created,
    #              count(case when status = 'closed' and DATE(updated_at) = day then 1 end) as closed,
    #              count(case when status != 'closed' then 1 end) as total
    #         FROM declarations
    #   RIGHT JOIN (
    #                SELECT date_trunc('day', days)::date AS day
    #                  FROM generate_series ('2017-01-01'::timestamp, '2017-12-31'::timestamp, '1 day'::interval) days
    #              ) days ON days.day = DATE(declarations.inserted_at)
    #     GROUP BY days.day
    #     ORDER BY days.day;

    query =
      from d in Declaration,
        where: d.doctor_id == ^params["doctor_id"],
        where: d.inserted_at >= ^params["start_date"],
        where: d.inserted_at <= ^params["end_date"]

    PRM.Repo.all(query)
  end
end
