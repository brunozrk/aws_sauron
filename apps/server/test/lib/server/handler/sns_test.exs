defmodule Server.Handler.SnsTest do
  use ExUnit.Case, async: false

  alias Server.Handler.Sns

  import Mox

  setup do
    stub_with(Server.Aws.Mock, Server.Test.AwsClientMock)

    allow(
      Server.Aws.Mock,
      self(),
      start_supervised!({Server.SnsData, skip_load: true})
    )

    Server.SnsData.refresh()

    :ok
  end

  describe "#subscriptions_by_arn/1" do
    test "filters subscriptions by arn endpoint" do
      assert Sns.subscriptions_by_arn("endpoint:queue_1") == [
               %{
                 endpoint: "endpoint:queue_1",
                 topic_arn: "topic_arn:sns_1"
               },
               %{
                 endpoint: "endpoint:queue_1",
                 topic_arn: "topic_arn:sns_2"
               }
             ]
    end

    test "returns empty list when endpoint doesnt match" do
      assert Sns.subscriptions_by_arn("unkown") == []
    end
  end
end
