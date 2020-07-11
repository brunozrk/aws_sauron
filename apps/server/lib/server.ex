defmodule Server do
  alias Server.Sqs
  alias Server.Sns

  def sqs(prefixes) do
    prefixes
    |> Sqs.list()
    |> Sns.subscriptions_by_queue()
  end
end
