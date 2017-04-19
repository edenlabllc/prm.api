defmodule PRM.Repo do
  @moduledoc false
  use Ecto.Repo, otp_app: :prm
  use Ecto.Pagging.Repo
end
