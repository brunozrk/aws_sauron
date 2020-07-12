defmodule Server.Parser do
  @url_regex ~r/.\/\/(\w+)\.([\w|-]+)\D+\/(\d+)\/(\w+)/

  def url_to_arn(url) do
    [[_, type, region, account_id, name]] = Regex.scan(@url_regex, url)

    "arn:aws:#{type}:#{region}:#{account_id}:#{name}"
  end
end
