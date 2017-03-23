defmodule PRM.Web.ReportController do
  @moduledoc false

  use PRM.Web, :controller

  def declarations(conn, params) do
    declarations = PRM.Declaration.Report.report(params)
    render(conn, "declarations_report.json", declarations: declarations)
  end
end
