defmodule :prm_tasks do
  @moduledoc """
  Nice way to apply migrations inside a released application.

  Example:

      prm/bin/prm command prm_tasks migrate!
  """
  alias Ecto.Migrator

  @priv_dir "priv"
  @repo PRM.Repo

  def migrate! do
    # Migrate
    migrations_dir = Path.join([@priv_dir, "repo", "migrations"])

    # Run migrations
    @repo
    |> start_repo
    |> Migrator.run(migrations_dir, :up, all: true)

    System.halt(0)
    :init.stop()
  end

  defp start_repo(repo) do
    start_applications([:logger, :postgrex, :ecto])
    :ok = Application.load(:prm)
    # If you don't include Repo in application supervisor start it here manually
    repo.start_link()
    repo
  end

  defp start_applications(apps) do
    Enum.each(apps, fn app ->
      {_, _message} = Application.ensure_all_started(app)
    end)
  end
end