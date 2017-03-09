defmodule PRM.Web.LaboursView do
  @moduledoc """
  View for Labours Schema
  """

  def render("labour.json", %{id: id}) do
    %{id: id, status: "processing"}
  end
end
