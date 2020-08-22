defmodule Server.Handler.Sqs do
  alias Server.Aws

  def list(prefix) do
    Aws.client().sqs_list_queues(prefix)
  end
end
