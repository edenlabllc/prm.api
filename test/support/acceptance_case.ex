defmodule PRM.Support.AcceptanceCase do
  @moduledoc """
  Acceptance test helper
  """
  use ExUnit.CaseTemplate

  using do
    repo =
      case System.get_env("CONTAINER_HTTP_PORT") do
        nil -> PRM.Repo
        _   -> nil
      end

    quote do
      @tag acceptance: true
      use EView.AcceptanceCase,
        async: false,
        otp_app: :prm,
        endpoint: PRM.Web.Endpoint,
        repo: unquote(repo),
        headers: [{"content-type", "application/json"}]

      def assert_validation_error(%HTTPoison.Response{body: body} = response, entry, type) do
        assert %{
          "meta" => %{"code" => 422},
          "error" => %{
            "message" => _,
            "type" => "validation_failed",
            "invalid" => [%{
              "entry" => ^entry,
              "entry_type" => ^type,
              "rules" => ["required"]
            }]
          },
        } = body

        response
      end

      def assert_status(%HTTPoison.Response{status_code: status_code} = response, status) do
        assert status == status_code
        response
      end

    end
  end
end
