defmodule Server.Test.AwsClientMock do
  @moduledoc """
    Mock for Server.Aws
  """

  alias Server.Aws

  @behaviour Aws

  @impl Aws
  def sqs_list_queues("queue") do
    [
      "https://sqs.sa-east-1.amazonaws.com/12345678/queue_1",
      "https://sqs.sa-east-1.amazonaws.com/12345678/queue_1_failures"
    ]
  end

  @impl Aws
  def sns_list_subscriptions(_next_token \\ nil) do
    %{
      next_token: "",
      subscriptions: [
        %{
          endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
          topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_1"
        },
        %{
          endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
          topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_2"
        },
        %{
          endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_2",
          topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_2"
        }
      ]
    }
  end

  @impl Aws
  def events_list_rule_names_by_target("arn:aws:sqs:sa-east-1:12345678:queue_1") do
    ["MyRule"]
  end

  @impl Aws
  def events_list_rule_names_by_target("arn:aws:sqs:sa-east-1:12345678:queue_1_failures") do
    []
  end

  @impl Aws
  def events_list_targets_by_rule("MyRule") do
    [
      %{"Arn" => "arn:aws:sqs:sa-east-1:12345678:queue_1", "Input" => "{\"type\": \"test\"}"},
      %{"Arn" => "arn:aws:sqs:sa-east-1:12345678:queue_1", "Input" => "{\"type\": \"test_2\"}"}
    ]
  end

  @impl Aws
  def events_list_rules("MyRule") do
    [
      %{
        "Name" => "MyRule",
        "State" => "ENABLED",
        "ScheduleExpression" => "* * * * *"
      }
    ]
  end
end
