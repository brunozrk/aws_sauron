defmodule Server.Aws do
  @moduledoc """
    Aws behaviour to be implemented in other Modules
  """

  alias Server.Aws.Client

  @type subscription :: %{
          endpoint: String.t(),
          topic_arn: String.t()
        }

  @type subscriptions :: %{
          next_token: String.t(),
          subscriptions: list(subscription)
        }

  @type rule_target ::
          %{
            # "Arn" => String.t(),
            # "Input" => String.t() | nil
          }

  @type rule ::
          %{
            # "Name" => String.t(),
            # "State" => String.t(),
            # "ScheduleExpression" => String.t()
          }

  @callback sqs_list_queues(prefix :: String.t()) :: list(String.t())

  @callback sns_list_subscriptions() :: subscriptions | {:error}
  @callback sns_list_subscriptions(next_token :: String.t()) :: subscriptions | {:error}

  @callback events_list_rule_names_by_target(target_arn :: String.t()) :: list(String.t()) | []
  @callback events_list_targets_by_rule(rule_name :: String.t()) :: list(rule_target) | []
  @callback events_list_rules(rule_name :: String.t()) :: list(rule) | []

  def client do
    Application.get_env(:server, :aws_mod) || Client
  end
end
