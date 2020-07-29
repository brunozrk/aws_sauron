defmodule Server.Events do
  alias Server.Aws

  def rules_by_arn(arn) do
    Aws.client().events_list_rule_names_by_target(arn)
    |> Enum.map(fn rule ->
      info = rule_info(arn, rule)

      %{
        rule: rule,
        input: target_inputs(arn, rule),
        status: info["State"],
        schedule: info["ScheduleExpression"]
      }
    end)
  end

  defp target_inputs(arn, rule) do
    Aws.client().events_list_targets_by_rule(rule)
    |> Enum.filter(&(&1["Arn"] == arn))
    |> Enum.map(&(&1["Input"] || ""))
  end

  defp rule_info(arn, rule) do
    Aws.client().events_list_rules(rule)
    |> Enum.find(&(&1["Name"] == rule))
  end
end
