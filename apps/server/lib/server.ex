defmodule Server do
  alias Server.Sqs
  alias Server.Sns
  alias Server.Events

  def sqs(prefixes) do
    prefixes
    |> Sqs.list()
    |> Enum.map(&Server.Parser.url_to_arn/1)
    |> Enum.map(fn arn ->
      %{
        arn: arn,
        subscriptions: Sns.subscriptions_by_arn(arn),
        rules: Events.rules_by_arn(arn)
      }
    end)
  end

  def sns(prefixes) do
    prefixes
    |> Sns.list()
  end
end
