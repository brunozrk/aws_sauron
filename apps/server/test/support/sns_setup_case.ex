defmodule SnsSetupCase do
  @moduledoc """
    Fallback to AwsClientMock when no expectations are defined.
  """
  use ExUnit.CaseTemplate

  import Mox

  alias Server.Aws.Mock, as: AwsMock
  alias Server.SnsData

  setup do
    stub_with(AwsMock, Server.Test.AwsClientMock)
    pid = start_supervised!({SnsData, skip_load: true})
    allow(AwsMock, self(), pid)

    SnsData.refresh()
    :sys.get_state(pid)

    :ok
  end
end
