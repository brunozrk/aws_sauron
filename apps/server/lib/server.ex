defmodule Server do
  alias Server.Aws
  alias Server.Handler.Events
  alias Server.Handler.Sns
  alias Server.Parser

  def sqs(prefixes, opts \\ []) do
    ignore_pattern = opts[:ignore_pattern] || ""

    prefixes
    |> list_queues(ignore_pattern)
    |> convert_url_to_arn()
    |> append_subscriptions_and_rules()
  end

  defp list_queues(prefixes, ignore_pattern) do
    Enum.map(prefixes, fn prefix ->
      queues = Aws.client().sqs_list_queues(prefix)

      queues =
        case ignore_pattern do
          "" -> queues
          _ -> queues |> Enum.filter(&(!(&1 =~ ignore_pattern)))
        end

      %{
        prefix: prefix,
        queues: queues
      }
    end)
  end

  defp convert_url_to_arn(queues) do
    Enum.map(queues, fn queue_map ->
      %{queue_map | queues: queue_map.queues |> Enum.map(&Parser.url_to_arn/1)}
    end)
  end

  defp append_subscriptions_and_rules(queues) do
    Enum.map(queues, fn queue_map ->
      %{
        queue_map
        | queues:
            queue_map.queues
            |> Enum.map(fn queue ->
              %{
                arn: queue,
                subscriptions: Sns.subscriptions_by_arn(queue),
                rules: Events.rules_by_arn(queue)
              }
            end)
      }
    end)
  end
end
