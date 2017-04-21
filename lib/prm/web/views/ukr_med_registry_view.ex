defmodule PRM.Web.UkrMedRegistryView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.UkrMedRegistryView

  def render("index.json", %{ukr_med_registries: ukr_med_registries}) do
    render_many(ukr_med_registries, UkrMedRegistryView, "ukr_med_registry.json")
  end

  def render("show.json", %{ukr_med_registry: ukr_med_registry}) do
    render_one(ukr_med_registry, UkrMedRegistryView, "ukr_med_registry.json")
  end

  def render("ukr_med_registry.json", %{ukr_med_registry: ukr_med_registry}) do
    %{id: ukr_med_registry.id,
      name: ukr_med_registry.name,
      edrpou: ukr_med_registry.edrpou,
      inserted_by: ukr_med_registry.inserted_by,
      inserted_at: ukr_med_registry.inserted_at,
      updated_by: ukr_med_registry.updated_by,
      updated_at: ukr_med_registry.updated_at,
    }
  end
end
