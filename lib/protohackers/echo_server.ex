defmodule Protohackers.EchoServer do
  use GenServer

  require Logger

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  defstruct [:listen_socket, :supervisor]

  @impl true
  def init(opts) do
    port = Keyword.fetch!(opts, :port)
    {:ok, supervisor} = Task.Supervisor.start_link(max_children: 100)

    case :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true, exit_on_close: false]) do
      {:ok, listen_socket} ->
        Logger.info("started echo server on port #{port}")
        state = %__MODULE__{listen_socket: listen_socket, supervisor: supervisor}
        {:ok, state, {:continue, :accept}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  @impl true
  def handle_continue(:accept, %__MODULE__{} = state) do
    case :gen_tcp.accept(state.listen_socket) do
      {:ok, socket} ->
        Task.Supervisor.start_child(state.supervisor, fn -> handle_connection(socket) end)
        {:noreply, state, {:continue, :accept}}

      {:error, reason} ->
        {:stop, reason}
    end
  end

  defp handle_connection(client) do
    case recv_until_closed(client, _buffer = "", _buffer_size = 0) do
      {:ok, data} ->
        :gen_tcp.send(client, data)

      {:error, reason} ->
        Logger.error("Error while receving bytes from client: #{inspect(reason)}")
    end

    :gen_tcp.close(client)
  end

  @limit _100_kb = 1024 * 100

  defp recv_until_closed(socket, buffer, buffer_size) do
    case :gen_tcp.recv(socket, 0, 10_000) do
      {:ok, data} when buffer_size + byte_size(data) > @limit ->
        {:error, :buffer_overflow}

      {:ok, data} ->
        recv_until_closed(socket, [buffer, data], byte_size(data) + buffer_size)

      {:error, :closed} ->
        {:ok, buffer}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
