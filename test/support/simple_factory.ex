defmodule PRM.SimpleFactory do
  @moduledoc false

  def doctor do
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

    elem(PRM.DoctorAPI.create_doctor(params), 1)
  end

  def msp do
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
    |> PRM..MSP.insert
    |> elem(1)
  end

  def product do
    params = %{
      name: "some_name",
      parameters: %{}
    }

    params
    |> PRM..Product.insert
    |> elem(1)
  end
end
