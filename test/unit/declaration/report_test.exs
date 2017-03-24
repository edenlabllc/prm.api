defmodule PRM.Declaration.ReportTest do
  use PRM.DataCase

  alias PRM.DeclarationAPI
  alias PRM.Declaration

  @create_attrs %{
    patient_id: Ecto.UUID.generate(),
    start_date: "2016-10-10 23:50:07.000000",
    end_date: "2016-12-07 23:50:07.000000",
    signature: "some_signrature_string",
    certificate: "some_certificate_string",
    status: "some_status_string",
    signed_at: "2016-10-09 23:50:07.000000",
    created_by: "some_author_identifier",
    updated_by: "some_editor_identifier",
    confident_person_id: Ecto.UUID.generate(),
    active: true
  }

  def fixture(:declaration, attrs \\ @create_attrs) do
    create_attrs =
      attrs
      |> Map.put_new(:doctor_id, PRM.SimpleFactory.doctor().id)
      |> Map.put_new(:msp_id, PRM.SimpleFactory.msp().id)

    {:ok, declaration} = DeclarationAPI.create_declaration(create_attrs)
    declaration
  end

  test "report" do
    declaration = fixture(:declaration)
    params = %{
      "start_date" => "2016-12-09",
      "end_date" => "2017-12-09",
      "doctor_id" => declaration.doctor_id,
      "msp_id" => declaration.msp_id
    }
    assert {:ok, list} = PRM.Declaration.Report.report(params)
    assert is_list(list)
  end
end
