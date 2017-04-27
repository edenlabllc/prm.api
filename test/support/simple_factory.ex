defmodule PRM.SimpleFactory do
  @moduledoc false

  alias PRM.{Entities, Parties, Employees, Registries}

  def fixture(:party), do: party()
  def fixture(:division), do: division()
  def fixture(:employee), do: employee()
  def fixture(:legal_entity), do: legal_entity()
  def fixture(:ukr_med_registry), do: ukr_med_registry()

  def legal_entity do
    attrs = %{
      "is_active" => true,
      "addresses" => [%{}],
      "inserted_by" => "026a8ea0-2114-11e7-8fae-685b35cd61c2",
      "edrpou" => rand_edrpou(),
      "email" => "some email",
      "kveds" => [],
      "legal_form" => "some legal_form",
      "name" => "some name",
      "owner_property_type" => "STATE",
      "phones" => [%{}],
      "public_name" => "some public_name",
      "short_name" => "some short_name",
      "status" => "VERIFIED",
      "type" => "MSP",
      "updated_by" => "1729f790-2114-11e7-97f0-685b35cd61c2",
      "medical_service_provider" => %{
        "licenses" => [%{
          "license_number" => "fd123443"
        }],
        "accreditation" => %{
          "category" => "перша",
          "order_no" => "me789123"
        }
      }
    }
    {:ok, legal_entity} = Entities.create_legal_entity(attrs)
    legal_entity
  end

  def ukr_med_registry do
    attrs = %{
      "name" => "some name",
      "edrpou" => rand_edrpou(),
      "inserted_by" => "026a8ea0-2114-11e7-8fae-685b35cd61c2",
      "updated_by" => "1729f790-2114-11e7-97f0-685b35cd61c2",
    }
    {:ok, ukr_med_registry} = Registries.create_ukr_med(attrs)
    ukr_med_registry
  end

  def rand_edrpou do
    9999999
    |> :rand.uniform()
    |> Kernel.+(10000000)
    |> to_string()
  end

  def division(type \\ "ambulant_clinic") do
    %{id: id} = legal_entity()
    attrs = %{
      "legal_entity_id" => id,
      "email" => "some email",
      "external_id" => "some external_id",
      "mountain_group" => "some mountain_group",
      "name" => "some name",
      "type" => type,
      "addresses" => [%{}],
      "phones" => [%{}],
    }
    {:ok, division} = Entities.create_division(attrs)
    division
  end

  def party do
    attrs = %{
      birth_date: ~D[1987-04-17],
      documents: [
        %{
          type: "NATIONAL_ID",
          number: "AA000000"
        }
      ],
      first_name: "some first_name",
      gender: "some gender",
      last_name: "some last_name",
      phones: [
        %{
          type: "MOBILE",
          number: "+380671112233"
        }
      ],
      second_name: "some second_name",
      tax_id: "some tax_id",
      inserted_by: "b17f0f82-4152-459e-9f10-a6662dfc0cf0",
      updated_by: "b17f0f82-4152-459e-9f10-a6662dfc0cf0"
    }
    {:ok, party} = Parties.create_party(attrs)
    party
  end

  def employee(employee_type \\ "doctor") do
    %{id: party_id} = party()
    %{id: division_id} = division()
    %{id: legal_entity_id} = legal_entity()

    attrs = %{
      "is_active" => true,
      "position" => "some position",
      "status" => "some status",
      "employee_type" => employee_type,
      "end_date" => ~N[2010-04-17 14:00:00.000000],
      "start_date" => ~N[2010-04-17 14:00:00.000000],
      "inserted_by" => "7488a646-e31f-11e4-aace-600308960662",
      "updated_by" => "7488a646-e31f-11e4-aace-600308960662",
      "party_id" => party_id,
      "division_id" => division_id,
      "legal_entity_id" => legal_entity_id,
    }

    attrs =
      case employee_type do
        "doctor" -> Map.put(attrs, "doctor", doctor())
         _ -> attrs
      end

    {:ok, employee} = Employees.create_employee(attrs)
    employee
  end

  def doctor do
    degrees = [
      "Молодший спеціаліст",
      "Бакалавр",
      "Спеціаліст",
      "Магістр"
    ]

    science_degrees = [
      "Доктор філософії",
      "Кандидат наук",
      "Доктор наук"
    ]

    specialities = [
      "Терапевт",
      "Педіатр",
      "Сімейний лікар",
    ]

    levels = [
      "Друга категорія",
      "Перша категорія",
      "Вища категорія"
    ]

    qualification_types = ~W(
      Присвоєння
      Підтвердження
    )

    types = [
      "Інтернатура",
      "Спеціалізація",
      "Передатестаційний цикл",
      "Тематичне вдосконалення",
      "Курси інформації",
      "Стажування",
    ]

    %{
      "science_degree" => %{
        "country" => "UA",
        "city" => "Kyiv",
        "degree" => Enum.random(science_degrees),
        "institution_name" => "random string",
        "diploma_number" => "random string",
        "speciality" => "random string",
        "issue_date" => 2000,
      },
      "qualifications" => [%{
        "type" => Enum.random(types),
        "institution_name" => "random string",
        "speciality" => Enum.random(specialities),
        "certificate_number" => "random string",
        "issue_date" => 2000,
      }],
      "educations" => [%{
        "country" => "UA",
        "city" => "Kyiv",
        "degree" => Enum.random(degrees),
        "institution_name" => "random string",
        "diploma_number" => "random string",
        "speciality" => "random string",
        "issued_at" => 2000,
      }],
      "specialities" => [%{
        "speciality" => Enum.random(specialities),
        "speciality_officio" => true,
        "level" => Enum.random(levels),
        "qualification_type" => Enum.random(qualification_types),
        "attestation_name" => "random string",
        "attestation_date" => 2000,
        "valid_to_date" => 2000,
        "certificate_number" => "random string",
      }]
    }
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
      inserted_by: "some_author_identifier",
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
