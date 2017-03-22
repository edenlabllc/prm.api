defmodule PRM.Web.ReportView do
  @moduledoc false

  use PRM.Web, :view

  alias PRM.Web.ReportView

  def render("declarations_report.json", %{declarations: declarations}) do
    render_many(declarations, ReportView, "declaration_report.json")
  end

  def render("declaration_report.json", %{report: report}) do
    %{
      date: report.date,
      declarations_total: report.total,
      declarations_created: report.created,
      declarations_closed: report.closed
    }
  end
end
