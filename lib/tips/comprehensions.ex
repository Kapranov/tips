defmodule Tips.Comprehensions do
  @moduledoc """
  Comprehensions are syntactic sugar: into the `for` special form.
  """

  @doc """
  Returns all the even numbers up to a given `number`.

  Returns a list of numbers.

  ## Examples:

      iex> Tips.Comprehensions.even(0)
      []
      iex> Tips.Comprehensions.even(1)
      []
      iex> Tips.Comprehensions.even(3)
      [3]
      iex> Tips.Comprehensions.even(10)
      [2, 4, 6, 8, 10]
  """
  @spec even(integer) :: list
  def even(number) do
    for n <- 1..number, n > 0, rem(n, 2) == 0, do: n
  end

  @doc """
  Joins a `list` of binaries together with a `separator`

  Returns a binary.

  ## Examples:

      iex> Tips.Comprehensions.join(["process", "supervisor"], "/")
      "/process/supervisor"
  """
  @spec join(list, String.t()) :: String.t()
  def join(list, separator) do
    for item <- list, into: "", do: "#{separator}#{item}"
  end
end
