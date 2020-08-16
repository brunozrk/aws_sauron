defmodule Server.SnsData do
  @name :sns_data
  @refresh_interval :timer.seconds(30)

  alias Server.Aws

  require Logger

  use GenServer

  defmodule SnsDataStruct do
    defstruct skip_load: false, subscriptions: []
  end

  def start_link(opts \\ []) do
    skip_load = opts[:skip_load] || false
    data = %SnsDataStruct{skip_load: skip_load}

    Logger.debug("Starting #{__MODULE__}...")
    GenServer.start_link(__MODULE__, data, name: @name)
  end

  def get_subscriptions() do
    GenServer.call(@name, :get_subscriptions)
  end

  def refresh() do
    send(@name, :refresh)
  end

  # callbacks

  def init(state) do
    if !state.skip_load do
      refresh()
    end

    {:ok, state}
  end

  def handle_info(:refresh, _state) do
    Logger.debug("refreshing data...")
    subs = all_subscriptions()
    Logger.debug("refreshing data finished.")

    Process.send_after(self(), :refresh, @refresh_interval)
    {:noreply, %SnsDataStruct{subscriptions: subs}}
  end

  def handle_call(:get_subscriptions, _from, state) do
    {:reply, state.subscriptions, state}
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
