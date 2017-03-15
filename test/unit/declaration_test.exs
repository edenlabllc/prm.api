defmodule PRM.Unit.DeclarationTest do
  @moduledoc false

  use PRM.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
      patient_id: Ecto.UUID.generate(),
      start_date: "2016-10-10 23:50:07",
      end_date: "2016-12-07 23:50:07",
      signature: "some_signrature_string",
      certificate: "some_certificate_string",
      status: "some_status_string",
      signed_at: "2016-10-09 23:50:07",
      created_by: "some_author_identifier",
      updated_by: "some_editor_identifier",
      confident_person_id: Ecto.UUID.generate(),
      active: true,
      doctor_id: doctor().id,
      msp_id: msp().id
    }

    assert {:ok, _} = PRM.Schemas.Declaration.insert(params)
  end
end
