defmodule Tips.Server do
  @moduledoc """
  A module to learn about how GenServers work.
  """

  alias Tips.Speaker

  @doc """
  Spawns off a process for a server where messages can
  be sent.  Process receives a message, prints the
  response to stdout, and returns the message sent.

  ## Example:

  ### Speaker (specifically)

      iex> server = Tips.Server.start(Tips.Speaker)
      server
      iex> send server, { :say, "Hello" }
      "Hello"
      { :say, "Hello" }

  ### PingPong

      iex> server = Tips.Server.start(Tips.PingPong)
      server
      iex> send server, :ping
      pong
      :ping
      iex> send server, :pong
      ping
      :pong
  """
  @spec start(atom) :: :ok
  def start(Speaker) do
    spawn(fn ->
      loop(Speaker)
    end)
  end

  @spec start(atom) :: :ok
  def start(callback_module) do
    parent = self()
    spawn fn ->
      loop(callback_module, parent)
    end
  end

  @spec start(atom, any) :: :ok
  def start(callback_module, state) do
    parent = self()
    spawn fn ->
      loop(callback_module, parent, state)
    end
  end

  @spec loop(atom) :: String.t()
  defp loop(Speaker) do
    receive do
      message ->
        Speaker.handle_message(message)
    end
    loop(Speaker)
  end

  @spec loop(atom, pid) :: String.t()
  defp loop(callback_module, parent) do
    receive do
      message ->
        callback_module.handle_message(message, parent)
        |> IO.puts
    end
    loop(callback_module, parent)
  end

  @spec loop(atom, pid, any) :: String.t()
  defp loop(callback_module, parent, state) do
    receive do
      message ->
        state = callback_module.handle_message(message, parent, state)
        IO.puts state
        loop(callback_module, parent, state)
    end
  end
end
