defmodule Tips.TodoList do
  @moduledoc false

  use GenServer

  @name __MODULE__

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> Tips.TodoList.start_link([struct])
      {:ok, pid}
  """
  @spec start_link([%Tips.TodoItem{description: String.t(), name: String.t()}]) :: :ok
  def start_link(list) do
    GenServer.start(@name, list, name: @name)
  end

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> {Ok, pid} = Tips.TodoList.start_link([struct])
      iex> struct = %Tips.TodoItem{name: "witten", description: "last name"}
      iex> Tips.TodoList.add_item(pid, struct)
      :ok
  """
  @spec add_item(pid, %Tips.TodoItem{description: String.t(), name: String.t()}) :: :ok
  def add_item(list, item) do
    GenServer.cast(list, {:add, item})
  end

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> {:ok, pid} = Tips.TodoList.start_link([struct])
      iex> struct = %Tips.TodoItem{name: "witten", description: "last name"}
      iex> Tips.TodoList.add_item(pid, struct)
      :ok
      iex> Tips.TodoList.show(pid)
      [
        %Tips.TodoItem{description: "last name", name: "witten"},
        %Tips.TodoItem{description: "first name", name: "oleg"}
      ]
      iex> Tips.TodoList.remove_item(pid, struct.name)
      :ok
      iex> Tips.TodoList.show(pid)
      [%Tips.TodoItem{description: "first name", name: "oleg"}]
  """
  @spec remove_item(pid, String.t()) :: :ok
  def remove_item(list, item_name) do
    GenServer.cast(list, {:remove, item_name})
  end

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> {:ok, pid} = Tips.TodoList.start_link([struct])
      iex> Tips.TodoList.show(pid)
      [%Tips.TodoItem{description: "first name", name: "oleg"}]
  """
  @spec show(pid) :: [%Tips.TodoItem{description: String.t(), name: String.t()}]
  def show(list) do
    GenServer.call(list, :show)
  end

  @impl true
  def init(list), do: {:ok, list}

  @impl true
  def handle_cast({:add, item}, list) do
    {:noreply, [item | list]}
  end

  @impl true
  def handle_cast({:remove, item_name}, list) do
    index =
      Enum.find_index(list, fn item ->
        item.name == item_name
      end)

    {:noreply, List.delete_at(list, index)}
  end

  @impl true
  def handle_call(:show, _from, list) do
    {:reply, list, list}
  end
end
