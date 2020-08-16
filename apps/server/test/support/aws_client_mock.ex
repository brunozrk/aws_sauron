defmodule Server.Test.AwsClientMock do
  alias Server.Aws

  @behaviour Aws

  @impl Aws
  def sqs_list_queues(_prefix), do: []

  @impl Aws
  def sns_list_subscriptions(_next_token \\ nil) do
    %{
      next_token: "",
      subscriptions: [
        %{
          endpoint: "endpoint:queue_1",
          topic_arn: "topic_arn:sns_1"
        },
        %{
          endpoint: "endpoint:queue_1",
          topic_arn: "topic_arn:sns_2"
        },
        %{
          endpoint: "endpoint:queue_2",
          topic_arn: "topic_arn:sns_2"
        }
      ]
    }
  end

  @impl Aws
  def events_list_rule_names_by_target(_target_arn), do: []

  @impl Aws
  def events_list_targets_by_rule(_rule_name), do: []

  @impl Aws
  def events_list_rules(_rule_name), do: []
end
