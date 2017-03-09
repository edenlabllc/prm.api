defmodule PRM.Web.LaboursView do
  @moduledoc """
  View for Labours Schema
  """
  use PRM.Web, :view

  def render("labour.json", %{id: id}) do
    %{id: id, status: "processing"}
  end
end
