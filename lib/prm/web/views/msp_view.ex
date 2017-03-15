defmodule PRM.Web.MSPView do
  @moduledoc false

  use PRM.Web, :view

  alias PRM.Web.MSPView

  def render("index.json", %{msps: msps}) do
    render_many(msps, MSPView, "msp.json")
  end

  def render("show.json", %{msp: msp}) do
    render_one(msp, MSPView, "msp.json")
  end

  def render("msp.json", %{msp: msp}) do
    %{
      id:             msp.id,
      name:           msp.name,
      short_name:     msp.short_name,
      type:           msp.type,
      edrpou:         msp.edrpou,
      services:       msp.services,
      licenses:       msp.licenses,
      accreditations: msp.accreditations,
      addresses:      msp.addresses,
      phones:         msp.phones,
      emails:         msp.emails,
      created_by:     msp.created_by,
      updated_by:     msp.updated_by,
      active:         msp.active
    }
  end
end
