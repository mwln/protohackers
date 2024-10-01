ExUnit.start()

defmodule TestGlobals do
  def get_client_tcp_opts do
    [:binary, active: false]
  end
end
