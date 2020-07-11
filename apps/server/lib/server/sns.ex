defmodule Server.Sns do
  def subscriptions_by_queue(queues) do
    subs = Server.SnsData.get_subscriptions()

    Enum.map(queues, &filter_by_queue(&1, subs))
  end

  def list(prefixes) do
    Server.SnsData.get_subscriptions()
    |> Enum.filter(fn s ->
      Enum.any?(prefixes, &(s.topic_arn =~ &1))
    end)
    |> Enum.group_by(& &1.topic_arn)
    |> Enum.map(fn {topic_arn, subscriptions} ->
      subscribers = Enum.map(subscriptions, &Server.Extractor.queue_name_from_arn(&1.endpoint))

      %{
        topic: Server.Extractor.topic_name_from_arn(topic_arn),
        subscribers: subscribers
      }
    end)
  end

  defp filter_by_queue(queue, subs) do
    subscriptions =
      subs
      |> Enum.filter(&(&1.endpoint =~ queue))
      |> Enum.map(&Server.Extractor.topic_name_from_arn(&1.topic_arn))

    %{
      queue: queue,
      subscriptions: subscriptions
    }
  end
end
