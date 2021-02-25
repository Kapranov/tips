defmodule Tips.Speaker do
  @moduledoc """
  Module that an implementation Elixir's `spawn`
  """

  @doc """
  An example method to learn how to use the `receive` macro.

  ## Examples:

      iex> pid = Kernel.spawn(Tips.Speaker, :speak, [])
      pid
      iex> send(pid, { :say, "Hello" })
      Hello
      {:say, "Hello"}
      iex> send(pid, { :message, "Hello" })
      {:message, "Hello"}

  """
  @spec speak() :: {:say, String.t()} | :error
  def speak do
    receive do
      {:say, msg} ->
        IO.puts(msg)
      _other -> :error
    end
  end

  @doc """
  Receives a message and either prints it to screen it
  the message is a `:say` tuple, otherwise ignores it
  """
  def handle_message({ :say, msg }), do: IO.puts(msg)
  def handle_message(_other), do: false
end
