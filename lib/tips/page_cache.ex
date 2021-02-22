defmodule Tips.PageCache do
  @moduledoc false

  use GenServer

  @name __MODULE__

  def start_link, do: GenServer.start_link(@name, [], name: :page_cache)

  def cached(key, fun), do: GenServer.call(:page_cache, {:cached, key, fun})

  def init(_), do: {:ok, Map.new()}

  def handle_call({:cached, key, fun}, _from, state) do
    case Map.get(state, key) do
      nil ->
        response = fun.()
        {:reply, response, Map.put(state, key, response)}

      response ->
        {:reply, response, state}
    end
  end
end
