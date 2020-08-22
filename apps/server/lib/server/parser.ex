defmodule Server.Parser do
  @moduledoc """
    Helper methods to parse aws values
  """

  @url_regex ~r/.\/\/(\w+)\.([\w|-]+)\D+\/(\d+)\/(\w+)/

  def url_to_arn(url) do
    case Regex.scan(@url_regex, url) do
      [[_, type, region, account_id, name]] ->
        "arn:aws:#{type}:#{region}:#{account_id}:#{name}"

      _ ->
        nil
    end
  end
end
