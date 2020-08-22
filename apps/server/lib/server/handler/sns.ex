defmodule Server.Handler.Sns do
  @moduledoc """
    Handles aws sns requests
  """

  def subscriptions_by_arn(arn) do
    Server.SnsData.get_subscriptions()
    |> Enum.filter(&(&1.endpoint == arn))
  end
end
