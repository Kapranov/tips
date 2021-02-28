defmodule Mix.Tasks.Encrypt do
  @shortdoc "Encrypts some arbitrary text"

  @moduledoc """
  Takes a -t option which specifies which text to encrypt.

  ## Example

      iex> mix encrypt -t hello
  """
  use Mix.Task

  @spec run([String.t()]) :: String.t()
  def run(args) do
    {opts, _, _} =
      OptionParser.parse(args, switches: [config_override: :string], aliases: [t: :text])

    IO.puts(Tips.Crypto.Encryptor.encrypt(opts[:text]))
  end
end
