defmodule Server.Sns do
  def subscriptions_by_queue(queues) do
    subs = all_subscriptions

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

  def all_subscriptions do
    {:ok, %{body: %{next_token: next_token, subscriptions: subscriptions}}} =
      ExAws.SNS.list_subscriptions() |> ExAws.request()

    list_subscriptions(subscriptions, next_token)
  end

  def list_subscriptions(subscriptions, ""), do: subscriptions

  def list_subscriptions(current_subscriptions, next_token) do
    {:ok, %{body: %{next_token: next_token, subscriptions: subscriptions}}} =
      ExAws.SNS.list_subscriptions(next_token) |> ExAws.request()

    list_subscriptions(subscriptions ++ current_subscriptions, next_token)
  end
end
