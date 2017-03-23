defmodule PRM.Declaration.Report do
  import Ecto.Query, only: [from: 2]

  alias PRM.Declaration

  def report(params) do
    query = "
          SELECT days.day,
                 count(declarations.id) as created,
                 count(case when status = 'closed' and DATE(updated_at) = day then 1 end) as closed,
                 count(case when status != 'closed' then 1 end) as total
            FROM declarations
      RIGHT JOIN (
                   SELECT date_trunc('day', series)::date AS day
                     FROM generate_series($1::timestamp, $2::timestamp, '1 day'::interval) series
                 ) days ON days.day = DATE(declarations.inserted_at) AND
                           doctor_id = $3 AND
                           msp_id = $4 AND
                           inserted_at >= DATE($5) AND
                           inserted_at <= DATE($6)
        GROUP BY days.day
        ORDER BY days.day;
    "

    sql_params = [
      params["start_date"],
      params["end_date"],
      params["doctor_id"],
      params["msp_id"],
      params["start_date"],
      params["end_date"]
    ]

    {:ok, result} = Ecto.Adapters.SQL.query(PRM.Repo, query, sql_params)

    Enum.map result.rows, fn item ->
      %{
        date: Date.from_erl!(Enum.at(item, 0)),
        created: Enum.at(item, 1),
        closed: Enum.at(item, 2),
        total: Enum.at(item, 3)
      }
    end
  end
end
