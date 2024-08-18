defmodule SmokeTest do
  @port 4040
  @options [:binary, active: false]

  def start do
    {:ok, socket} = :gen_tcp.listen(@port, @options)
    IO.puts("server started on port #{@port}...")
    accept(socket)
  end

  defp accept(listen_socket) do
    {:ok, conn} = :gen_tcp.accept(listen_socket)
    IO.puts("listening...")
    spawn(fn -> recv(conn) end)
    accept(listen_socket)
  end

  defp recv(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        IO.puts("data received: #{inspect(data)}")
        :gen_tcp.send(conn, data)
        recv(conn)

      {:error, :closed} ->
        :ok
    end
  end
end
