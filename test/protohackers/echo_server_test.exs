defmodule Protohackers.EchoServerTest do
  use ExUnit.Case

  @host ~c"localhost"
  @port 4001
  @opts [:binary, active: false]

  test "echoes back data sent" do
    {:ok, socket} = :gen_tcp.connect(@host, @port, @opts)
    assert :gen_tcp.send(socket, "foo") == :ok
    assert :gen_tcp.send(socket, "bar") == :ok
    :gen_tcp.shutdown(socket, :write)
    assert :gen_tcp.recv(socket, 0, 5000) == {:ok, "foobar"}
  end

  test "echo server obeys the max buffer size" do
    {:ok, socket} = :gen_tcp.connect(@host, @port, @opts)
    assert :gen_tcp.send(socket, :binary.copy("a", 1024 * 100 + 1)) == :ok
    assert :gen_tcp.recv(socket, 0) == {:error, :closed}
  end
end
