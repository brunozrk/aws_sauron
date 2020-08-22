defmodule Web.PageViewTest do
  use Web.ConnCase, async: true

  alias Web.PageView

  describe "#mermaid/1" do
    test "transform sqs list into mermaid list" do
      assert PageView.mermaid(sqs_list()) == [
               "graph TD",
               "subgraph 0",
               "queuep[queue]:::prefix --> queuesqs[queue_1_failures]:::sqs",
               "queuep[queue]:::prefix --> queue_1:::sqs",
               "queue_1 --> queue_1t(sns_1<br/>sns_2):::sns",
               "queue_1 --> queue_1f(\"MyRule <br/> - schedule: * * * * * <br/> - input: {'type': 'test'} {'type': 'test_2'} <br/> - status: ENABLED\"):::cloudwatch",
               "end",
               "classDef prefix fill:#242b3b,color:#fff",
               "classDef sqs fill:#cca352",
               "classDef sns fill:#b37a99",
               "classDef cloudwatch fill:#748f49"
             ]
    end
  end

  defp sqs_list do
    [
      %{
        prefix: "queue",
        queues: [
          %{
            arn: "arn:aws:sqs:sa-east-1:12345678:queue_1",
            rules: [
              %{
                input: ["{\"type\": \"test\"}", "{\"type\": \"test_2\"}"],
                rule: "MyRule",
                schedule: "* * * * *",
                status: "ENABLED"
              }
            ],
            subscriptions: [
              %{
                endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
                topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_1"
              },
              %{
                endpoint: "arn:aws:sqs:sa-east-1:12345678:queue_1",
                topic_arn: "arn:aws:sns:sa-east-1:12345678:sns_2"
              }
            ]
          },
          %{
            arn: "arn:aws:sqs:sa-east-1:12345678:queue_1_failures",
            rules: [],
            subscriptions: []
          }
        ]
      }
    ]
  end
end
