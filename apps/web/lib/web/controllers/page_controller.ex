defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    render(conn, "index.html", info: '', prefixes: '', ignore_pattern: '')
  end

  def create(conn, params) do
    %{"filter" => %{"ignore_pattern" => ignore_pattern, "prefixes" => prefixes}} = params

    mermaid_list =
      prefixes
      |> String.split(",")
      |> Server.sqs(ignore_pattern: ignore_pattern)
      |> Web.PageView.mermaid()
      |> Enum.join("\n")

    render(conn, "index.html",
      info: mermaid_list,
      prefixes: prefixes,
      ignore_pattern: ignore_pattern
    )
  end
end
