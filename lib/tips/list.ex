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

  defp do_length([], count), do: count
  defp do_length([_head | tail], count), do: do_length(tail, count + 1)
end
