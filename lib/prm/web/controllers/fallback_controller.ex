defmodule PRM.Web.FallbackController do
  @moduledoc false

  use PRM.Web, :controller

  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(EView.Views.PhoenixError, :"404")
  end

  def call(conn, %Ecto.Changeset{valid?: false} = changeset), do: call(conn, {:error, changeset})

  def call(conn, {:error, %Ecto.Changeset{valid?: false} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(EView.Views.ValidationError, :"422", changeset)
  end
end
