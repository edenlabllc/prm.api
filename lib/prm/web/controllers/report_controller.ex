defmodule PRM.Web.ReportController do
  @moduledoc false

  use PRM.Web, :controller

  def declarations(conn, params) do
    with {:ok, declarations} <- PRM.Declaration.Report.report(params) do
      render(conn, "declarations_report.json", declarations: declarations)
    end
  end
end
