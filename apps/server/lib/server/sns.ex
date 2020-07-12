defmodule Server.Sns do
  def subscriptions_by_arn(arn) do
    all_subscriptions() |> Enum.filter(&(&1.endpoint == arn))
  end

  def list(prefixes) do
    all_subscriptions()
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

  def all_subscriptions() do
    Server.SnsData.get_subscriptions()
  end
end
