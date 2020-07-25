defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", info: '', prefixes: '', ignore_pattern: '')
  end

  def create(conn, params) do
    %{"filter" => %{"ignore_pattern" => ignore_pattern, "prefixes" => prefixes}} = params

    prefixes_list = String.split(prefixes, ",")

    sqs_list = Server.sqs(prefixes_list, ignore_pattern: ignore_pattern)
    mermaid_list = Web.PageView.mermaid(sqs_list) |> Enum.join("\n")

    render(conn, "index.html",
      info: mermaid_list,
      prefixes: prefixes,
      ignore_pattern: ignore_pattern
    )
  end
end
