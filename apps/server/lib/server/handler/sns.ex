defmodule Server.Handler.Sns do
  def subscriptions_by_arn(arn) do
    Server.SnsData.get_subscriptions()
    |> Enum.filter(&(&1.endpoint == arn))
  end
end
