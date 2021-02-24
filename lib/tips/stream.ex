defmodule Tips.Stream do
  @moduledoc """
  Module thait an implementation Elixir's `stream`.
  """

  @monthes ~w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

  @doc """
  Create a Stream of all the months in a year.

  ## Example

      iex> Tips.Stream.month
      #Stream<[
        enum: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        funs: [#Function<38.92508066/1 in Stream.each/2>]
      ]>
  """
  @spec month :: fun
  def month do
    @monthes
    |> Stream.each(&IO.puts/1)
  end

  @doc """
  Render created a stream of all the months in a year

  ## Example

      iex> Tips.Stream.get_month
      :ok
  """
  @spec get_month :: :ok
  def get_month do
    month()
    |> Stream.run()
  end

  @doc """
  Write a function that returns every other word in the `priv/sample.txt`
  file which starts with “D”, sorted by length and capitalized.

  ## Example

      iex> Tips.Stream.sample
      ["Desk", "Drum", "Dung", "Dress", "Drill", "Drink", "Diamond", "Data base"]
  """
  @spec sample(String.t()) :: [String.t()]
  def sample(name \\ "sample.txt") do
    path = Path.join(:code.priv_dir(:tips), name)

    File.stream!(path)
    |> Stream.take_every(2)
    |> Stream.filter(&String.starts_with?(&1, "d"))
    |> Stream.map(fn word ->
      word
      |> String.trim()
      |> String.capitalize()
    end)
    |> Enum.sort_by(&String.length/1)
  end
end
