defmodule ServerTest do
  use SnsSetupCase, async: false

  import Mox

  setup :verify_on_exit!

  describe "#sqs/1" do
    test "returns the hierarchy" do
      assert Server.sqs(["queue"]) == [
               %{
                 prefix: "queue",
                 queues: [queue_response(), queue_failure_response()]
               }
             ]
    end
  end

  describe "#sqs/2" do
    test "ignoring, returns the hierarchy without ignored pattern" do
      assert Server.sqs(["queue"], ignore_pattern: "failures") == [
               %{
                 prefix: "queue",
                 queues: [queue_response()]
               }
             ]
    end
  end

  defp queue_response do
    %{
      arn: "arn:aws:sqs:sa-east-1:12345678:queue_1",
      rules: [
        %{
          input: ["{\"type\": \"test\"}", "{\"type\": \"test_2\"}"],
          rule: "MyRule",
          schedule: "* * * * *",
          status: "ENABLED"
        }
      ],
      subscriptions: [
        %{
          endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
          topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_1"
        },
        %{
          endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
          topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_2"
        }
      ]
    }
  end

  defp queue_failure_response do
    %{
      arn: "arn:aws:sqs:sa-east-1:12345678:queue_1_failures",
      rules: [],
      subscriptions: []
    }
  end
end
