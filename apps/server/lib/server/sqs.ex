defmodule Server.Sqs do
  def list_queues(prefix) do
    case ExAws.SQS.list_queues(queue_name_prefix: prefix) |> ExAws.request() do
      {:ok, response} ->
        response.body.queues

      _ ->
        []
    end
  end
end
