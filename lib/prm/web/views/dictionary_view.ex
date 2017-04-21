defmodule PRM.Web.DictionaryView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.DictionaryView

  def render("index.json", %{dictionaries: dictionaries}) do
    render_many(dictionaries, DictionaryView, "dictionary.json")
  end

  def render("show.json", %{dictionary: dictionary}) do
    render_one(dictionary, DictionaryView, "dictionary.json")
  end

  def render("dictionary.json", %{dictionary: dictionary}) do
    %{
      name: dictionary.name,
      values: dictionary.values,
      labels: dictionary.labels,
      is_active: dictionary.is_active
    }
  end
end
