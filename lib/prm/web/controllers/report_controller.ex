defmodule PRM.Web.ReportController do
  @moduledoc false

  use PRM.Web, :controller

  def declarations(conn, params) do
    declarations = PRM.Declaration.Report.report(params)
    render(conn, "declarations_report.json", declarations: declarations)
    # + start_date: 2017-01-28 (string, required)
    # + end_date: 2017-02-28 (string, required)
    # + doctor_id: b075f148-7f93-4fc2-b2ec-2d81b19a9b7b (string, optional)
    # + msp_id: b
  end
end
