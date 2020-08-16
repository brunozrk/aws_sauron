defmodule Server.SnsDataTest do
  use ExUnit.Case, async: false

  alias Server.SnsData

  import Mox

  setup :verify_on_exit!

  @expected_response_1 %{
    next_token: "123",
    subscriptions: [
      %{
        endpoint: "endpoint:queue_1",
        topic_arn: "topic_arn:sns_1"
      },
      %{
        endpoint: "endpoint:queue_1",
        topic_arn: "topic_arn:sns_2"
      }
    ]
  }

  @expected_response_2 %{
    next_token: "",
    subscriptions: [
      %{
        endpoint: "endpoint:queue_2",
        topic_arn: "topic_arn:sns_2"
      }
    ]
  }

  describe "#handle_info/2 :refresh" do
    test "calls sns_list_subscriptions and refresh its state" do
      expect(Server.Aws.Mock, :sns_list_subscriptions, fn -> @expected_response_1 end)
      expect(Server.Aws.Mock, :sns_list_subscriptions, fn "123" -> @expected_response_2 end)

      {:noreply, %{subscriptions: subscriptions}} = SnsData.handle_info(:refresh, [])

      assert subscriptions ==
               @expected_response_2.subscriptions ++ @expected_response_1.subscriptions
    end
  end

  describe "#handle_call/3 :get_subscriptions" do
    test "get subscriptions from current state" do
      state = %{subscriptions: ["test"]}
      assert SnsData.handle_call(:get_subscriptions, nil, state) == {:reply, ["test"], state}
    end
  end

  describe "starting the server" do
    test "skip_load true does not call sns_list_subscriptions" do
      expect(Server.Aws.Mock, :sns_list_subscriptions, 0, fn -> nil end)

      pid = start_supervised!({SnsData, skip_load: true})
      allow(Server.Aws.Mock, self(), pid)

      :sys.get_state(pid)
    end

    test "#refresh/0 and get_subscriptions/0" do
      pid = start_supervised!({SnsData, skip_load: true})
      allow(Server.Aws.Mock, self(), pid)

      expect(Server.Aws.Mock, :sns_list_subscriptions, 1, fn -> @expected_response_2 end)

      assert SnsData.get_subscriptions() == []

      Server.SnsData.refresh()

      :sys.get_state(pid)

      assert SnsData.get_subscriptions() == @expected_response_2.subscriptions
    end
  end
end
