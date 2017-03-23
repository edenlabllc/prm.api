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
                     FROM generate_series('#{params["start_date"]}'::timestamp, '#{params["end_date"]}'::timestamp, '1 day'::interval) series
                 ) days ON days.day = DATE(declarations.inserted_at) AND
                           doctor_id = '#{params["doctor_id"]}' AND
                           msp_id = '#{params["msp_id"]}' AND
                           inserted_at >= DATE('#{params["start_date"]}') AND
                           inserted_at <= DATE('#{params["end_date"]}')
        GROUP BY days.day
        ORDER BY days.day;
    "

    {:ok, result} = Ecto.Adapters.SQL.query(PRM.Repo, query, [])

    IO.inspect result

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
