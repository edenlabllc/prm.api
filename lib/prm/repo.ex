defmodule PRM.Repo do
  @moduledoc false
  use Ecto.Repo, otp_app: :prm
  use Ecto.Paging.Repo
end
