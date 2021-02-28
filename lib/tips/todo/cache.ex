defmodule Tips.Todo.Cache do
  @moduledoc false
  use GenServer
  import String, only: [to_atom: 1]
  alias __MODULE__, as: Cache

  @doc """
  ## Example:

      iex> Tips.Todo.Cache.start_link([])
      {:ok, pid}
  """
  @spec start_link(list) :: {:ok, pid}
  def start_link(list) when is_list(list) do
    GenServer.start_link(Cache, list, name: Cache)
  end

  def start_link(_), do: {:error, message: "Argument is not correct!"}

  @doc """
  ## Example:

      iex> Tips.Todo.Cache.save(%{name: "Josh"})
      true
  """
  @spec save(%{name: String.t()}) :: boolean
  def save(list) when is_map(list) do
    try do
      if list == %{} do
        false
      else
        :ets.insert(Cache, {to_atom(list.name), list})
      end
    rescue
      ArgumentError -> false
    end
  end

  @spec save(any) :: boolean
  def save(_), do: false

  @doc """
  ## Example:

      iex> Tips.Todo.Cache.find("Josh")
      %{name: "Josh"}
  """
  @spec find(String.t()) :: %{name: String.t()} | nil
  def find(list_name) when is_bitstring(list_name) do
    case :ets.lookup(Cache, to_atom(list_name)) do
      [{_id, value}] -> value
      [] -> nil
    end
  end

  @spec find(any) :: nil
  def find(_), do: nil

  @doc """
  ## Example:

      iex> Tips.Todo.Cache.clear
      true
  """
  @spec clear() :: boolean
  def clear do
    :ets.delete_all_objects(Cache)
  end

  @impl true
  def init(_) do
    table = :ets.new(Cache, [:named_table, :public])
    {:ok, table}
  end
end
