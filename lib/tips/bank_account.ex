defmodule Tips.BankAccount do
  @moduledoc false

  @name __MODULE__

  @doc """
  ## Example:

      iex> pid = Tips.BankAccount.start(100)
      pid
  """
  @spec start(integer) :: pid
  def start(balance) do
    {:ok, account} = GenServer.start(@name, balance, name: @name)
    account
  end

  @doc """
  ## Example:

      iex> pid = Tips.BankAccount.start(100)
      pid
      iex> Tips.BankAccount.deposit(pid, 201)
      :ok
      iex> Tips.BankAccount.balance(pid)
      100
      iex> Tips.BankAccount.deposit(pid, 2)
      :ok
      iex> Tips.BankAccount.balance(pid)
      102
  """
  @spec deposit(pid, integer) :: :ok
  def deposit(account, amount) do
    GenServer.cast(account, {:deposit, amount})
  end

  @doc """
  ## Example:

      iex> pid = Tips.BankAccount.start(100)
      pid
      iex> Tips.BankAccount.withdraw(pid, 99)
      :ok
      iex> Tips.BankAccount.balance(pid)
      100
      iex> Tips.BankAccount.withdraw(pid, 90)
      :ok
      iex> Tips.BankAccount.balance(pid)
      10
  """
  @spec withdraw(pid, integer) :: :ok
  def withdraw(account, amount) do
    GenServer.cast(account, {:withdraw, amount})
  end

  @doc """
  ## Example:

      iex> pid = Tips.BankAccount.start(100)
      pid
      iex> Tips.BankAccount.balance(pid)
      100
  """
  @spec balance(pid) :: integer
  def balance(account) do
    GenServer.call(account, :balance)
  end

  def init(balance), do: {:ok, balance}

  def handle_cast({:deposit, amount}, balance) do
    if amount > balance + 100 do
      {:noreply, balance}
    else
      {:noreply, balance + amount}
    end
  end

  def handle_cast({:withdraw, amount}, balance) do
    if amount > balance - 10 do
      {:noreply, balance}
    else
      {:noreply, balance - amount}
    end
  end

  def handle_call(:balance, _from, balance) do
    {:reply, balance, balance}
  end

  def handle_message({:deposit, amount}, _from, balance) do
    balance + amount
  end

  def handle_message({:withdraw, amount}, _from, balance) do
    balance - amount
  end

  def handle_message(:balance, from, balance) do
    send(from, {:balance, balance})
    balance
  end
end
