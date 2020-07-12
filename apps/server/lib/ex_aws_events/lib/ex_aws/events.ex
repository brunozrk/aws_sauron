defmodule ExAws.Events do
  @moduledoc """
  Operations on AWS Events
  """

  @namespace "AWSEvents"

  @spec list_rule_names_by_target(target_arn :: binary) :: ExAws.Operation.JSON.t()
  def list_rule_names_by_target(target_arn, opts \\ []) do
    params =
      opts
      |> format_regular_opts
      |> Map.put("TargetArn", target_arn)

    request(:list_rule_names_by_target, params)
  end

  @spec list_targets_by_rule(rule :: binary) :: ExAws.Operation.JSON.t()
  def list_targets_by_rule(rule, opts \\ []) do
    params =
      opts
      |> format_regular_opts
      |> Map.put("Rule", rule)

    request(:list_targets_by_rule, params)
  end

  @spec list_rules(opts :: [name_prefix: binary]) :: ExAws.Operation.JSON.t()
  def list_rules(opts \\ []) do
    params =
      opts
      |> format_regular_opts

    request(:list_rules, params)
  end

  defp format_regular_opts(opts) do
    opts
    |> Enum.into(%{}, fn {k, v} ->
      {format_param_key(k), v}
    end)
  end

  defp format_param_key(key) do
    key
    |> Atom.to_string()
    |> ExAws.Utils.camelize()
  end

  defp request(op, data, opts \\ %{}) do
    operation =
      op
      |> Atom.to_string()
      |> Macro.camelize()

    ExAws.Operation.JSON.new(
      :events,
      %{
        data: data,
        headers: [
          {"x-amz-target", "#{@namespace}.#{operation}"},
          {"content-type", "application/x-amz-json-1.1"}
        ]
      }
      |> Map.merge(opts)
    )
  end
end
