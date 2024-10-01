defmodule Protohackers.Application do
  use Application

  alias Protohackers.EchoServer

  @echo 4001

  @impl true
  def start(_type, _args) do
    children = [
      {EchoServer, port: @echo}
    ]

    opts = [strategy: :one_for_one, name: Protohackers.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get_echo_port do
    @echo
  end
end
