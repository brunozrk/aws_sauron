defmodule Server.Sns do
  def subscriptions_by_queue(queues) do
    subs = Server.SnsData.get_subscriptions()

    Enum.map(queues, &filter_by_queue(&1, subs))
  end

  def filter_by_queue(queue, subs) do
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
