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

  @doc """
  Sums the elements of a given `list`.

  Returns the sum total of the `list` elements as an integer.

  ## Examples:

      iex> Tips.List.sum([])
      0
      iex> Tips.List.sum([1, 2, 3])
      6
  """
  @spec sum(list) :: integer
  def sum(list), do: do_sum(list, 0)

  @doc """
  Iterates over the contents of a given `list`, performs a
  function `fun` on each element of the `list`, and returns the
  result of recursively processing the return value of each of the
  function calls.

  Returns a result based on calling function `fun` on each member
  of the given `list` as an integer.

  ## Examples:

      iex> Tips.List.reduce([], fn(n, acc) -> acc + n end)
      nil
      iex> Tips.List.reduce([2], fn(_x, acc) -> acc + 5 end)
      2
      iex> Tips.List.reduce([1, 2, 3, 4], fn(n, acc) -> acc + n end)
      10
      iex> Tips.List.reduce([1, 2, 3, 4], fn(n, acc) -> acc * n end)
      24
  """
  @spec reduce(list, fun) :: integer | nil
  def reduce(list, fun), do: do_reduce(list, fun)

  @doc """
  Reverses the contents of a given `list`.

  Returns a list.

  ## Examples:

      iex> Tips.List.reverse([])
      []
      iex> Tips.List.reverse([1])
      [1]
      iex> Tips.List.reverse([1, 2, 3])
      [3, 2, 1]
      iex> Tips.List.reverse(["a", "b", "c"])
      ["c", "b", "a"]
  """
  @spec reverse(list) :: list
  def reverse(list), do: do_reverse(list)

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

  @spec do_sum(list, integer) :: integer
  defp do_sum([], count), do: count

  defp do_sum([head | tail], count) do
    count = count + head
    do_sum(tail, count)
  end

  @spec do_reduce(list, fun) :: integer | nil
  defp do_reduce([], _fun), do: nil
  defp do_reduce([head | nil], _fun), do: head
  defp do_reduce([head | tail], fun), do: do_reduce(tail, head, fun)

  @spec do_reduce(list, integer, fun) :: integer | nil
  defp do_reduce([], acc, _fun), do: acc

  defp do_reduce([head | tail], acc, fun) do
    acc = fun.(head, acc)
    do_reduce(tail, acc, fun)
  end

  @spec do_reverse(list) :: list
  defp do_reverse([]), do: []
  defp do_reverse([head | tail]), do: do_reverse(tail, [head])

  @spec do_reverse(list, list) :: list
  defp do_reverse([], acc), do: acc

  defp do_reverse([head | tail], acc) do
    acc = [head | acc]
    do_reverse(tail, acc)
  end
end
