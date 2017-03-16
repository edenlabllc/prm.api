defmodule PRM.Web.DeclarationView do
  @moduledoc false

  use PRM.Web, :view

  alias PRM.Web.DeclarationView

  def render("index.json", %{declarations: declarations}) do
    render_many(declarations, DeclarationView, "declaration.json")
  end

  def render("show.json", %{declaration: declaration}) do
    render_one(declaration, DeclarationView, "declaration.json")
  end

  def render("declaration.json", %{declaration: declaration}) do
    %{
       id:                  declaration.id,
       patient_id:          declaration.patient_id,
       start_date:          declaration.start_date,
       end_date:            declaration.end_date,
       signature:           declaration.signature,
       certificate:         declaration.certificate,
       status:              declaration.status,
       signed_at:           declaration.signed_at,
       created_by:          declaration.created_by,
       updated_by:          declaration.updated_by,
       confident_person_id: declaration.confident_person_id,
       doctor_id:           declaration.doctor_id,
       msp_id:              declaration.msp_id
    }
  end
end
