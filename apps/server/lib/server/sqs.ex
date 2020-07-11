defmodule Server.Sqs do
  def list(prefixes) do
    Enum.flat_map(prefixes, fn prefix ->
      case ExAws.SQS.list_queues(queue_name_prefix: prefix) |> ExAws.request() do
        {:ok, response} ->
          response.body.queues
          |> Enum.map(&Server.Extractor.queue_name_from_url(&1))
      end
    end)
  end
end
