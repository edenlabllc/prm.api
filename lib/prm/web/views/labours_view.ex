defmodule PRM.Web.LaboursView do
  use PRM.Web, :view

  def render("labour.json", %{id: id}) do
    %{id: id, status: "processing"}
  end
end
