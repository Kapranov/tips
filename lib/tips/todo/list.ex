defmodule Tips.Todo.List do
  @moduledoc false

  use GenServer
  alias Tips.Todo.Cache

  @name __MODULE__

  @doc """
  ## Example:

      iex> Tips.Todo.Cache.start_link([])
      {:ok, pid}
      iex> {:ok, pid} = Tips.Todo.List.start_link("Home")
  """
  @spec start_link(String.t()) :: {:ok, pid}
  def start_link(name) do
    GenServer.start_link(@name, name, name: {:global, name})
  end

  @doc """
  ## Example:

      iex> Tips.Todo.List.name(pid)
      "Home"
  """
  @spec name(pid) :: String.t()
  def name(pid) when is_pid(pid) do
    GenServer.call(pid, :name)
  end

  def name(_), do: {:error, message: "PID doesn't exist"}

  @doc """
  ## Example:

      iex> Tips.Todo.List.items(pid)
      []
  """
  @spec items(pid) :: [] | [%Tips.Todo.Item{completed: boolean, description: String.t(), id: integer}]
  def items(pid) when is_pid(pid) do
    GenServer.call(pid, :items)
  end

  def items(_), do: {:error, message: "PID doesn't exist"}

  @doc """
  ## Example:

      iex> item = Tips.Todo.Item.new("Create an OTP app")
      %Tips.Todo.Item{
        completed: false,
        description: "Create an OTP app",
        id: 841813076
      }
      iex> Tips.Todo.List.add(pid, item)
      iex> :ok
      iex> Tips.Todo.List.items(pid)
      [
        %Tips.Todo.Item{
          completed: false,
          description: "Create an OTP app",
          id: 841813076
        }
      ]
  """
  @spec add(pid, %Tips.Todo.Item{completed: boolean, description: String.t(), id: integer}) :: :ok
  def add(pid, item) when is_pid(pid) and is_map(item) do
    GenServer.cast(pid, {:add, item})
  end

  def add(_, _), do: {:error, message: "PID doesn't exist or item is not struct"}

  @doc """
  ## Example:

      iex> updated_item = %{item | description: "new", completed: true}
      iex> Tips.Todo.List.update(pid, updated_item)
      :ok
      iex> Tips.Todo.List.items(pid)
      [%Tips.Todo.Item{completed: true, description: "new", id: 841813076}]
  """
  @spec update(pid, %Tips.Todo.Item{completed: boolean, description: String.t(), id: integer}) :: :ok
  def update(pid, item) when is_pid(pid) and is_map(item) do
    GenServer.cast(pid, {:update, item})
  end

  def update(_, _), do: {:error, message: "PID doesn't exist or item is not struct"}

  @impl true
  @spec init(String.t) :: {:ok, %{items: [], name: String.t()}}
  def init(name) do
    state = Cache.find(name) || %{name: name, items: []}
    {:ok, state}
  end

  @impl true
  def handle_call(:name, _from, state) do
    {:reply, state.name, state}
  end

  @impl true
  def handle_call(:items, _from, state) do
    {:reply, state.items, state}
  end

  @impl true
  def handle_cast({:add, item}, state) do
    state = %{state | items: [item | state.items]}
    Cache.save(state)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:update, item}, state) do
    index = Enum.find_index(state.items, &(&1.id == item.id))
    items = List.replace_at(state.items, index, item)
    state = %{state | items: items}
    Cache.save(state)
    {:noreply, state}
  end
end
