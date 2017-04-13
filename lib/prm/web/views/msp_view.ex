defmodule PRM.Web.MSPView do
  use PRM.Web, :view
  alias PRM.Web.MSPView

  def render("index.json", %{medical_service_providers: medical_service_providers}) do
    %{data: render_many(medical_service_providers, MSPView, "msp.json")}
  end

  def render("show.json", %{msp: msp}) do
    %{data: render_one(msp, MSPView, "msp.json")}
  end

  def render("msp.json", %{msp: msp}) do
    %{id: msp.id,
      accreditation: msp.accreditation,
      license: msp.license}
  end
end
