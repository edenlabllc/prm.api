defmodule PRM.Utils.Connection do
  @moduledoc """
  Plug.Conn helpers
  """

  @header_consumer_id "x-consumer-id"

  def get_consumer_id(%Plug.Conn{req_headers: req_headers}) do
    get_consumer_id(req_headers)
  end

  def get_consumer_id(headers) do
    get_header(headers, @header_consumer_id)
  end

  def get_header(headers, header) when is_list(headers) do
    list = for {k, v} <- headers, k == header, do: v
    List.first(list)
  end
end
