defmodule Tips.EtsPageCache do
  @moduledoc """
  A global key-value store where you can safely store data and read from it,
  without the need to synchronize through processes. This. is exactly what
  Elang Term Storage (ETS) can do for you. ETS is a separate memory-data
  structure where you can store Erlang terms. This makes it possible to share
  the system-wide state without introducing a dedicated server process.
  The data is kept in an ETS table - a dynamic memory structure where you can
  store tuples.
  """

  use GenServer

  @name __MODULE__

  @doc """
  Start a new EtsPageCache process.

  ## Example:

      iex> {:ok, pid} = Tips.EtsPageCache.start_link
      {:ok, pid}
  """
  @spec start_link() :: {:ok, pid}
  def start_link, do: GenServer.start_link(@name, [], name: :ets_page_cache)

  @doc """
  Tha cache is read from client processes, meaning there won't be any blocked
  reads. There will be no message passing between clients and the cache process
  and readers won't mutually block themselves. `cached/2` function, which accepts
  a key, and a lambda. If you have something cached for the key, you'll return
  the value. Otherwise, you must forward the request to cache process.

  ## Example:

      iex> Tips.EtsPageCache.cached(:index, &Tips.WebServer.index/0)
      "<html><h2>Crazy Nancy Pelosi Releases Bizarre Video on $15 Minimum Wage.</h2></html>"
  """
  @spec cached(atom, fun) :: String.t()
  def cached(key, fun) do
    read_cached(key) || GenServer.call(:ets_page_cache, {:cached, key, fun})
  end

  @doc false
  def init(_) do
    :ets.new(:ets_page_cache, [:set, :named_table, :protected])
    {:ok, nil}
  end

  def handle_call({:cached, key, fun}, _from, state) do
    {:reply, read_cached(key) || cache_response(key, fun), state}
  end

  @spec read_cached(atom) :: String.t() | nil
  defp read_cached(key) do
    case :ets.lookup(:ets_page_cache, key) do
      [{^key, cached}] -> cached
      _ -> nil
    end
  end

  @spec cache_response(atom, fun) :: String.t()
  defp cache_response(key, fun) do
    response = fun.()
    :ets.insert(:ets_page_cache, {key, response})
    response
  end
end
