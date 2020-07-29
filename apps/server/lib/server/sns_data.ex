defmodule Server.SnsData do
  @name :sns_data
  @refresh_interval :timer.seconds(30)

  alias Server.Aws

  require Logger

  use GenServer

  def start_link(_) do
    Logger.info("Starting #{__MODULE__}...")
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_subscriptions() do
    GenServer.call(@name, :get_subscriptions)
  end

  # callbacks

  def init(_state) do
    subs = all_subscriptions()
    schedule_refresh()

    {:ok, subs}
  end

  def handle_info(:refresh, _state) do
    Logger.info("refreshing data...")
    subs = all_subscriptions()
    schedule_refresh()

    {:noreply, subs}
  end

  def handle_call(:get_subscriptions, _from, state) do
    {:reply, state, state}
  end

  defp schedule_refresh() do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp all_subscriptions() do
    %{next_token: next_token, subscriptions: subscriptions} =
      Aws.client().sns_list_subscriptions()

    list_subscriptions(subscriptions, next_token)
  end

  defp list_subscriptions(subscriptions, ""), do: subscriptions

  defp list_subscriptions(current_subscriptions, next_token) do
    %{next_token: next_token, subscriptions: subscriptions} =
      Aws.client().sns_list_subscriptions(next_token)

    list_subscriptions(subscriptions ++ current_subscriptions, next_token)
  end
end
