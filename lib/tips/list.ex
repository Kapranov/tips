defmodule Tips.List do
  @moduledoc """
  Module that emulates functionality in Elixir's Enum module.
  """

  @doc """
  Calculates the length of a given `list`.

  Returns the length of the `list` as an integer.

  ## Examples:

      iex> Tips.List.length([])
      0
      iex> Tips.List.length([1, 2, 3])
      3
  """
  @spec length(list) :: integer
  def length(list), do: do_length(list, 0)

  @doc """
  Iterates over the contents of a given `list` and performs a
  function on each element of the `list`.

  Returns `:ok`.

  ## Example

      iex> Tips.List.each([], fn(x) -> x end)
      :ok
      iex> Tips.List.each([1, 2, 3], &(IO.puts to_string(&1)))
      "1"
      "2"
      "3"
      :ok
  """
  @spec each(list, fun) :: :ok
  def each(list, fun), do: do_each(list, fun)

  @doc """
  Iterates over the contents of a given `list`, performs a
  function on each element of the `list`, and returns a new
  list with the results.

  Returns a list of results based on calling function `fun`
  on each member of the given `list`.

  ## Example

      iex> Tips.List.map([], fn(x) -> x end)
      []
      iex> Tips.List.map([1, 2, 3], fn(n) -> n * 2 end)
      [2, 4, 6]
  """
  @spec map(list, fun) :: list
  def map(list, fun), do: do_map(list, fun, [])

  @spec do_length(list, integer) :: integer
  defp do_length([], count), do: count
  defp do_length([_head | tail], count), do: do_length(tail, count + 1)

  @spec do_each(list, fun) :: :ok
  defp do_each([], _fun), do: :ok

  defp do_each([head | tail], fun) do
    fun.(head)
    do_each(tail, fun)
  end

  @spec do_map(list, fun, []) :: :ok
  defp do_map([], _fun, acc), do: :lists.reverse(acc)

  defp do_map([head | tail], fun, acc) do
    result = fun.(head)
    acc = [result | acc]
    do_map(tail, fun, acc)
  end
end
