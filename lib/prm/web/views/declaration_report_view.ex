defmodule PRM.Web.ReportView do
  @moduledoc false

  use PRM.Web, :view

  alias PRM.Web.ReportView

  def render("declarations_report.json", %{declarations: declarations}) do
    render_many(declarations, ReportView, "declaration_report.json")
  end

  def render("declaration_report.json", %{declaration_report: declaration_report}) do
    %{
      date: declaration_report.date,
      declarations_total: declaration_report.total,
      declarations_created: declaration_report.created,
      declarations_closed: declaration_report.closed
    }
  end
end
