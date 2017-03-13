defmodule Prm.Unit.DeclarationTest do
  use ExUnit.Case, async: true

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PRM.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PRM.Repo, {:shared, self()})
    end

    :ok
  end

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
      msp_id: msp().id,
    }

    IO.inspect msp()

    assert {:ok, _} = Prm.Declaration.insert(params)
  end

  defp doctor do
    params = %{
      mpi_id: "some_mpi_id_string",
      status: "some_status_string",
      education: [],
      certificates: [],
      licenses: [],
      jobs: [],
      active: true,
      name: "Vasilii Poupkine",
      created_by: "some_author_identifier",
      updated_by: "some_editor_identifier"
    }

    params
    |> Prm.Doctor.insert
    |> elem(1)
  end

  defp msp do
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

    params
    |> Prm.MSP.insert
    |> elem(1)
  end
end
