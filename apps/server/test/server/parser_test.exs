defmodule Server.ParserText do
  use ExUnit.Case, async: true

  alias Server.Parser

  describe "#url_to_arn/1" do
    test "converts url to arn" do
      url = "https://sqs.sa-east-1.amazonaws.com/12345678/my_queue"

      assert Parser.url_to_arn(url) == "arn:aws:sqs:sa-east-1:12345678:my_queue"
    end

    test "unknown url returns nil" do
      url = "unknown"

      assert Parser.url_to_arn(url) == nil
    end
  end
end
