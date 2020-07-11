defmodule Server.Extractor do
  def queue_name_from_url(url) do
    "https://sqs.sa-east-1.amazonaws.com/" <> tail = url
    [account_id, name] = String.split(tail, "/")
    name
  end

  def topic_name_from_arn(arn) do
    "arn:aws:sns:sa-east-1:" <> tail = arn
    [account_id, name] = String.split(tail, ":")
    name
  end
end
