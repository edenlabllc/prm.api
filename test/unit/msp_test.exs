defmodule Prm.Unit.MspTest do
  use Prm.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
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

    assert {:ok, _} = Prm.MSP.insert(params)
  end
end
