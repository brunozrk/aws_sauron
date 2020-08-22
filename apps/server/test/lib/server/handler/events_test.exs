defmodule Server.Handler.EventsTest do
  use ExUnit.Case, async: true

  import Mox

  alias Server.Aws.Mock, as: AwsMock
  alias Server.Handler.Events

  setup :verify_on_exit!

  describe "#rules_by_arn" do
    test "returns rules with its info" do
      arn = "arn:aws:sqs:sa-east-1:12345678:my_queue"
      rule_name = "MyRule"

      rules = [
        %{
          "Name" => "MyRule",
          "State" => "ENABLED",
          "ScheduleExpression" => "* * * * *"
        },
        %{
          "Name" => "MyRuleOld",
          "State" => "Disabled",
          "ScheduleExpression" => "* * * * *"
        }
      ]

      rule_targets = [
        %{"Arn" => arn, "Input" => "{\"type\": \"test\"}"},
        %{"Arn" => arn, "Input" => "{\"type\": \"test_2\"}"},
        %{"Arn" => "other_arn", "Input" => ""}
      ]

      expect(AwsMock, :events_list_rule_names_by_target, fn ^arn -> [rule_name] end)
      expect(AwsMock, :events_list_rules, fn ^rule_name -> rules end)
      expect(AwsMock, :events_list_targets_by_rule, fn ^rule_name -> rule_targets end)

      expected_result = [
        %{
          rule: rule_name,
          input: ["{\"type\": \"test\"}", "{\"type\": \"test_2\"}"],
          status: "ENABLED",
          schedule: "* * * * *"
        }
      ]

      assert Events.rules_by_arn(arn) == expected_result
    end
  end

  test "when arn does not have any rule, returns empty list" do
    arn = "arn_no_rules"

    expect(AwsMock, :events_list_rule_names_by_target, fn ^arn -> [] end)

    assert Events.rules_by_arn(arn) == []
  end
end
