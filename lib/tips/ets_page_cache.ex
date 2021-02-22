defmodule Tips.EtsPageCache do
  @moduledoc """
  """

  use GenServer

  @name __MODULE__

  def start_link, do: GenServer.start_link(@name, [], name: :ets_page_cache)

  def cached(key, fun) do
    read_cached(key) || GenServer.call(:ets_page_cache, {:cached, key, fun})
  end

  def init(_) do
    :ets.new(:ets_page_cache, [:set, :named_table, :protected])
    {:ok, nil}
  end

  def handle_call({:cached, key, fun}, _from, state) do
    {:reply, read_cached(key) || cache_response(key, fun), state}
  end

  defp read_cached(key) do
    case :ets.lookup(:ets_page_cache, key) do
      [{^key, cached}] -> cached
      _ -> nil
    end
  end

  defp cache_response(key, fun) do
    response = fun.()
    :ets.insert(:ets_page_cache, {key, response})
    response
  end
end