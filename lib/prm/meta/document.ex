defmodule PRM.Meta.Document do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset, warn: false

  @fields ~w(
    type
    number
  )a

  @derive {Poison.Encoder, except: [:__meta__]}

  @primary_key false

  schema "documents" do
    field :type, :string
    field :number, :string
  end

  def changeset(%PRM.Meta.Document{} = doc, attrs) do
    doc
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_inclusion(:type, ["PASSPORT", "NATIONAL_ID", "BIRTH_CERTIFICATE", "TEMPORARY_CERTIFICATE"])
  end
end
