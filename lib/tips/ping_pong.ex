defmodule Tips.PingPong do
  @moduledoc """
  A simple ping pong module that handles :ping messages
  by returning :pong, and vice versa
  """

  @doc """
  Method that returns :pong when it receives :ping,
  and returns :ping when it receives :pong
  """
  def handle_message(:ping, from), do: send from, :pong
  def handle_message(:pong, from), do: send from, :ping
end
