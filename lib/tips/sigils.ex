defmodule Tips.Sigils do
  @moduledoc """
  Module that an implementation Elixir's `sigil`-related.
  """

  import Kernel, except: [sigil_r: 2]

  @doc """
  Create a new sigil ~u that will return a list of upcased words from
  the given `content`.

  Returns a list of upcased words.

  ## Example:

      iex> Tips.Sigils.sigil_u("hello", nil)
      ["HELLO"]
  """
  @spec sigil_u(String.t(), any) :: [String.t()]
  def sigil_u(content, _opts) do
    content
    |> String.split()
    |> Enum.map(&String.upcase/1)
  end

  @doc """
  Overrides the ~r sigil to reverse a string rather than have return
  a regular expression.

  ## Example:

      iex> Tips.Sigils.sigil_r("hello", nil)
      "olleh"
  """
  @spec sigil_r(String.t(), any) :: String.t()
  def sigil_r(content, _opts), do: String.reverse(content)

  @doc """
  A simple method that uses the overidden version of the ~r sigil.

  Returns "olleh".

  ## Example:

      iex> Tips.Sigils.hello_sigil_r
      "olleh"
  """
  @spec hello_sigil_r :: String.t()
  def hello_sigil_r do
    ~r/hello/
  end
end
