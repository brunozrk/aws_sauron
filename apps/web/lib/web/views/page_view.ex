defmodule Web.PageView do
  use Web, :view

  def mermaid(sqs_list) do
    mermaid_list = ["graph TD"]

    result =
      sqs_list
      |> Enum.with_index()
      |> Enum.flat_map(fn {prefix_map, idx} ->
        [queues_without_info, queues_with_info] = split_queues(prefix_map[:queues])

        ["subgraph #{idx}"] ++
          queues_without_info_connection(queues_without_info, prefix_map) ++
          queues_with_info_connections(queues_with_info, prefix_map) ++
          ["end"]
      end)

    style_definitions = [
      "classDef prefix fill:#242b3b,color:#fff",
      "classDef sqs fill:#cca352",
      "classDef sns fill:#b37a99",
      "classDef cloudwatch fill:#748f49"
    ]

    mermaid_list ++ result ++ style_definitions
  end

  defp queues_without_info_connection(queues_without_info, prefix_map) do
    queues_without_info_text =
      queues_without_info
      |> Enum.map(fn queue -> queue_name_from_arn(queue[:arn]) end)
      |> Enum.join("<br/>")

    case queues_without_info_text do
      "" ->
        []

      _ ->
        [
          "#{prefix_map[:prefix]}p[#{prefix_map[:prefix]}]:::prefix --> #{prefix_map[:prefix]}sqs[#{
            queues_without_info_text
          }]:::sqs"
        ]
    end
  end

  defp queues_with_info_connections(queues_with_info, prefix_map) do
    queues_with_info
    |> Enum.flat_map(fn queue ->
      queue_name = queue_name_from_arn(queue[:arn])

      root_connection =
        "#{prefix_map[:prefix]}p[#{prefix_map[:prefix]}]:::prefix --> #{queue_name}:::sqs"

      topics =
        queue[:subscriptions]
        |> Enum.map(fn sns -> topic_name_from_arn(sns[:topic_arn]) end)
        |> Enum.join("<br/>")

      topics_connection =
        case topics do
          "" -> []
          _ -> ["#{queue_name} --> #{queue_name}t(#{topics}):::sns"]
        end

      rules =
        queue[:rules]
        |> Enum.map(fn rule ->
          input = rule[:input] |> Enum.join(" ") |> String.replace("\"", "'")

          "\"#{rule[:rule]} <br/> - schedule: #{rule[:schedule]} <br/> - input: #{input} <br/> - status: #{
            rule[:status]
          }\""
        end)
        |> Enum.join("<br/>")

      rules_connection =
        case rules do
          "" -> []
          _ -> ["#{queue_name} --> #{queue_name}f(#{rules}):::cloudwatch"]
        end

      [root_connection] ++ topics_connection ++ rules_connection
    end)
  end

  defp split_queues(queues) do
    queues_without_info =
      Enum.filter(queues, fn queue ->
        queue[:rules] == [] && queue[:subscriptions] == []
      end)

    queues_with_info =
      Enum.filter(queues, fn queue ->
        !Enum.member?(queues_without_info, queue)
      end)

    [queues_without_info, queues_with_info]
  end

  defp queue_name_from_arn(arn) do
    "arn:aws:sqs:" <> tail = arn
    [_region, _account_id, name] = String.split(tail, ":")
    name
  end

  defp topic_name_from_arn(arn) do
    "arn:aws:sns:" <> tail = arn
    [_region, _account_id, name] = String.split(tail, ":")
    name
  end
end
