defmodule SmokeTestTest do
  use ExUnit.Case
  alias SmokeTest

  @port 4040
  @options [:binary, active: false]

  setup_all do
    spawn(SmokeTest, :start, [])

    :ok
  end

  setup do
    {:ok, socket} = :gen_tcp.connect(~c"localhost", @port, @options)

    on_exit(fn ->
      :gen_tcp.close(socket)
      :timer.sleep(100)
    end)

    {:ok, listen_socket: socket}
  end

  test "echo server echoes back data", %{listen_socket: socket} do
    :ok = :gen_tcp.send(socket, "hello")

    assert {:ok, "hello"} = :gen_tcp.recv(socket, 0)
  end

  test "echo server handles multiple messages", %{listen_socket: socket} do
    :ok = :gen_tcp.send(socket, "foo")
    assert {:ok, "foo"} = :gen_tcp.recv(socket, 0)

    :ok = :gen_tcp.send(socket, "bar")
    assert {:ok, "bar"} = :gen_tcp.recv(socket, 0)
  end
end
