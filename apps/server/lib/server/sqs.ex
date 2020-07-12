defmodule Server.Sqs do
  def list(prefixes, opts \\ []) do
    ignore_pattern = opts[:ignore_pattern]

    Enum.flat_map(prefixes, fn prefix ->
      case ExAws.SQS.list_queues(queue_name_prefix: prefix) |> ExAws.request() do
        {:ok, response} ->
          response.body.queues

          case ignore_pattern do
            nil -> response.body.queues
            _ -> response.body.queues |> Enum.filter(&(!(&1 =~ ignore_pattern)))
          end

        _ ->
          []
      end
    end)
  end
end
