defmodule Tips.Parallel do
  @moduledoc """
  Example module demonstrating parallel processes
  """

  @doc """
  Parallel map function that takes in a `collection` and `fun`
  function and performs a function call on each member of the
  collection in a separate process.

  Returns a collection of values

  ## Example:

      iex> Tips.Parallel.pmap(1..10, &(&1 * &1))
      [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
  """
  @spec pmap(Enumerable, fun) :: [integer]
  def pmap(collection, fun) do
    collection
    |> Enum.map(&spawn_process(&1, self(), fun))
    |> Enum.map(&await/1)
  end

  @spec spawn_process(integer, pid, fun) :: pid
  defp spawn_process(item, parent, fun) do
    spawn_link(fn ->
      send(parent, {self(), fun.(item)})
    end)
  end

  @spec await(pid) :: integer
  defp await(pid) do
    receive do
      {^pid, result} -> result
    end
  end
end
