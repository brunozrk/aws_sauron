defmodule Server.Aws.Client do
  alias Server.Aws
  alias ExAws.SQS
  alias ExAws.SNS
  alias ExAws.Events

  @behaviour Aws

  @impl Aws
  def sqs_list_queues(prefix) do
    case SQS.list_queues(queue_name_prefix: prefix) |> ExAws.request() do
      {:ok, response} ->
        response.body.queues

      _ ->
        []
    end
  end

  @impl Aws
  def sns_list_subscriptions(next_token \\ nil) do
    query =
      case next_token do
        nil -> SNS.list_subscriptions()
        _ -> SNS.list_subscriptions(next_token)
      end

    case ExAws.request(query) do
      {:ok, %{body: body}} ->
        body

      _ ->
        {:error}
    end
  end

  @impl Aws
  def events_list_rule_names_by_target(target_arn) do
    case Events.list_rule_names_by_target(target_arn) |> ExAws.request() do
      {:ok, %{"RuleNames" => rules}} ->
        rules

      _ ->
        []
    end
  end

  @impl Aws
  def events_list_targets_by_rule(rule_name) do
    case ExAws.Events.list_targets_by_rule(rule_name) |> ExAws.request() do
      {:ok, %{"Targets" => targets}} ->
        targets

      _ ->
        []
    end
  end

  @impl Aws
  def events_list_rules(rule_name) do
    case ExAws.Events.list_rules(name_prefix: rule_name) |> ExAws.request() do
      {:ok, %{"Rules" => rules}} ->
        rules

      _ ->
        []
    end
  end
end
