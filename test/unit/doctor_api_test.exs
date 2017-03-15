defmodule PRM.Unit.DoctorAPITest do
  @moduledoc false

  use PRM.UnitCase, async: true

  alias PRM.DoctorAPI

  test "search doctor validation" do
    assert %{valid?: false} = DoctorAPI.search_doctor(%{})
    assert %{valid?: false} = DoctorAPI.search_doctor(%{"invalid" => true})
    assert %{valid?: false} = DoctorAPI.search_doctor(%{"area" => nil})

    fields = ~W(
      first_name
      last_name
      second_name
      speciality
      region
      area
    )
    for field <- fields,
        do: assert %{valid?: true} = DoctorAPI.search_doctor(%{field => "asd"})
  end
end
