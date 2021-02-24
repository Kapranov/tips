defmodule Tips.BankAccountStruct do
  @moduledoc false

  @name __MODULE__

  defstruct balance: 0

  @doc """
  ## Example:

      iex> account = Tips.BankAccountStruct.new(100)
      %Tips.BankAccountStruct{balance: 100}
  """
  @spec new(integer) :: %Tips.BankAccountStruct{balance: integer}
  def new(balance) do
     %@name{ balance: balance }
  end

  @doc """
  ## Example:

      iex> account = Tips.BankAccountStruct.new(100)
      %Tips.BankAccountStruct{balance: 100}
      iex> Tips.BankAccountStruct.deposit(account, 99)
      %Tips.BankAccountStruct{balance: 199}
  """
  @spec deposit(%Tips.BankAccountStruct{balance: integer}, integer) :: %Tips.BankAccountStruct{balance: integer}
  def deposit(account, amount) do
    %{ account | balance: account.balance + amount }
  end

  @doc """
  ## Example:

      iex> account = Tips.BankAccountStruct.new(100)
      %Tips.BankAccountStruct{balance: 100}
      iex> Tips.BankAccountStruct.withdraw(account, 99)
      %Tips.BankAccountStruct{balance: 1}
  """
  @spec withdraw(%Tips.BankAccountStruct{balance: integer}, integer) :: %Tips.BankAccountStruct{balance: integer}
  def withdraw(account, amount) do
    %{ account | balance: account.balance - amount }
  end

  @doc """
  ## Example:

      iex> account = Tips.BankAccountStruct.new(100)
      %Tips.BankAccountStruct{balance: 100}
      iex> Tips.BankAccountStruct.balance(account)
      100
  """
  @spec balance(%Tips.BankAccountStruct{balance: integer}) :: integer
  def balance(account) do
    account.balance
  end
end
