defmodule Server.Handler.SnsTest do
  use SnsSetupCase, async: false

  alias Server.Handler.Sns

  describe "#subscriptions_by_arn/1" do
    test "filters subscriptions by arn endpoint" do
      assert Sns.subscriptions_by_arn("arn:aws:sqs:sa-east-1:12345678:queue_1") == [
               %{
                 endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
                 topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_1"
               },
               %{
                 endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
                 topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_2"
               }
             ]
    end

    test "returns empty list when endpoint doesnt match" do
      assert Sns.subscriptions_by_arn("unkown") == []
    end
  end
end
