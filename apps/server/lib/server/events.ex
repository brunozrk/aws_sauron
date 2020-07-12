defmodule Server.Events do
  def rules_by_arn(arn) do
    case ExAws.Events.list_rule_names_by_target(arn) |> ExAws.request() do
      {:ok, %{"RuleNames" => rules}} ->
        Enum.map(rules, fn rule ->
          info = rule_info(arn, rule)

          %{
            rule: rule,
            input: target_inputs(arn, rule),
            status: info["State"],
            schedule: info["ScheduleExpression"]
          }
        end)

      _ ->
        []
    end
  end

  defp target_inputs(arn, rule) do
    case ExAws.Events.list_targets_by_rule(rule) |> ExAws.request() do
      {:ok, %{"Targets" => targets}} ->
        targets
        |> Enum.filter(&(&1["Arn"] == arn))
        |> Enum.map(&(&1["Input"] || ""))

      _ ->
        []
    end
  end

  defp rule_info(arn, rule) do
    case ExAws.Events.list_rules(name_prefix: rule) |> ExAws.request() do
      {:ok, %{"Rules" => infos}} ->
        infos
        |> Enum.find(&(&1["Name"] == rule))

      _ ->
        %{}
    end
  end
end
