defmodule Server do
  alias Server.Sqs
  alias Server.Sns

  def sqs(prefixes) do
    prefixes
    |> Sqs.list()
    |> Enum.map(&Server.Parser.url_to_arn/1)
    |> Sns.subscriptions_by_arn()
  end

  def sns(prefixes) do
    prefixes
    |> Sns.list()
  end
end
