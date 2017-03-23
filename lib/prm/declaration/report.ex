defmodule PRM.Declaration.Report do
  @moduledoc false

  import Ecto.Changeset, warn: false

  alias Ecto.Adapters.SQL

  def report(%Ecto.Changeset{valid?: false} = changeset), do: changeset
  def report(%Ecto.Changeset{valid?: true} = changeset) do
    start_date = get_change(changeset, :start_date)
    end_date = get_change(changeset, :end_date)
    query = "
          SELECT days.day,
                 count(declarations.id) as created,
                 count(case when status = 'closed' and DATE(updated_at) = day then 1 end) as closed,
                 count(case when status != 'closed' then 1 end) as total
            FROM declarations
      RIGHT JOIN (
                   SELECT date_trunc('day', series)::date AS day
                   FROM generate_series('#{start_date}'::timestamp, '#{end_date}'::timestamp, '1 day'::interval) series
                 ) days ON days.day = DATE(declarations.inserted_at) AND
                           doctor_id = '#{get_change(changeset, :doctor_id)}' AND
                           msp_id = '#{get_change(changeset, :msp_id)}' AND
                           inserted_at >= DATE('#{start_date}') AND
                           inserted_at <= DATE('#{end_date}')
        GROUP BY days.day
        ORDER BY days.day;
    "

    {:ok, result} = SQL.query(PRM.Repo, query)

    list = Enum.map result.rows, fn item ->
      %{
        date: Date.from_erl!(Enum.at(item, 0)),
        created: Enum.at(item, 1),
        closed: Enum.at(item, 2),
        total: Enum.at(item, 3)
      }
    end
    {:ok, list}
  end

  def report(params) do
    params
    |> report_changeset()
    |> report()
  end

  def report_changeset(attrs) do
    data = %{}
    types = %{
      start_date: :naive_datetime,
      end_date: :naive_datetime,
      msp_id: Ecto.UUID,
      doctor_id: Ecto.UUID,
    }
    required_fields = [
      :start_date,
      :end_date,
      :msp_id,
      :doctor_id,
    ]

    {data, types}
    |> cast(attrs, Map.keys(types))
    |> validate_required(required_fields)
  end
end
