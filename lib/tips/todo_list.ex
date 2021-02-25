defmodule Tips.TodoList do
  @moduledoc false

  use GenServer

  @name __MODULE__

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> pid = Tips.TodoList.start(struct)
      pid
  """
  @spec start(%Tips.TodoItem{description: String.t(), name: String.t()}) :: :ok
  def start(list) do
     {:ok, todo_list } = GenServer.start(@name, list, name: @name)
     todo_list
  end

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> pid = Tips.TodoList.start(struct)
      pid
      iex> struct = %Tips.TodoItem{name: "witten", description: "last name"}
      iex> Tips.TodoList.add_item(pid, struct)
      :ok
  """
  @spec add_item(pid, %Tips.TodoItem{description: String.t(), name: String.t()}) :: :ok
  def add_item(list, item) do
    GenServer.cast(list, { :add, item })
  end

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> pid = Tips.TodoList.start(struct)
      pid
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
      %Tips.TodoItem{description: "first name", name: "oleg"}
  """
  @spec remove_item(pid, String.t()) :: :ok
  def remove_item(list, item_name) do
    GenServer.cast(list, { :remove, item_name })
  end

  @doc """
  ## Example:

      iex> struct = %Tips.TodoItem{description: "first name", name: "oleg"}
      iex> pid = Tips.TodoList.start(struct)
      pid
      iex> Tips.TodoList.show(pid)
      %Tips.TodoItem{description: "first name", name: "oleg"}
  """
  @spec show(pid) :: [%Tips.TodoItem{description: String.t(), name: String.t()}] | %Tips.TodoItem{description: String.t(), name: String.t()}
  def show(list) do
    GenServer.call(list, :show)
  end

  def init(list), do: { :ok, list }

  def handle_cast({ :add, item }, list) do
    { :noreply, [item] ++ [list] }
  end

  def handle_cast({ :remove, item_name }, list) do
    index =
      Enum.find_index(list, fn(item) ->
        item.name == item_name
      end)
    { :noreply, List.delete_at(list, index) }
  end

  def handle_call(:show, _from, list) do
    { :reply, list, list }
  end
end
