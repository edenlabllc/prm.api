defmodule PRM.SimpleFactory do
  @moduledoc false

  def legal_entity do

  end

  def msp do
    %{
      id: "47e7f952-203f-11e7-bdfc-685b35cd61c2",
      name: "some_name",
      short_name: "some_shortname_string",
      type: "some_type_string",
      edrpou: "some_edrpou_string",
      services: [],
      licenses: [],
      accreditations: [],
      addresses: [],
      phones: [],
      emails: [],
      created_by: "some_author_identifier",
      updated_by: "some_editor_identifier",
      active: true
    }
  end

  def product do
    params = %{
      name: "some_name",
      parameters: %{}
    }

    params
    |> PRM.Product.insert
    |> elem(1)
  end
end
