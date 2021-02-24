defmodule Tips.Crypto.Encryptor do
  @moduledoc false
  @name __MODULE__
  @prefix Application.get_env(:tips, @name)[:prefix]

  @doc """
  Reverse text via mix environment

  ## Example

      iex> Tips.Crypto.Encryptor.encrypt("hello")
      "Dev: olleh"
  """
  @spec encrypt(String.t()) :: String.t()
  def encrypt(text), do: @prefix <> String.reverse(text)
end
