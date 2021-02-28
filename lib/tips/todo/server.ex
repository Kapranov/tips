defmodule Tips.Todo.Server do
  @moduledoc false

  use DynamicSupervisor
  alias __MODULE__, as: Server

  @type child :: pid() | :undefined
  @type error_atom :: :ignore
  @type error_child_tuple :: {:error, {:already_started, child()} | :already_present | term()}
  @type error_tuple :: {:error, {:already_started, pid()} | {:shutdown, term()} | term()}
  @type on_start :: success_tuple | error_atom | error_tuple
  @type on_start_child :: success_child_tuple | error_child_tuple
  @type success_child_tuple :: {:ok, child()} | {:ok, child(), info :: term()}
  @type success_tuple :: {:ok, pid()}

  @spec start_link(any) :: on_start()
  def start_link(_arg) do
    DynamicSupervisor.start_link(Server, :ok, name: Server)
  end

  @doc """
  ## Example:

      iex> Tips.Todo.Server.add_list("find-by-name")
      {:ok, pid}
  """
  @spec add_list(String.t()) :: on_start_child()
  def add_list(name) do
    child_spec = {Tips.Todo.List, {name}}
    DynamicSupervisor.start_child(Server, child_spec)
  end

  @doc """
  ## Example:

      iex> Server.find_list("find-by-name")
      pid
  """
  @spec find_list(String.t()) :: pid() | nil
  def find_list(name) do
    Enum.find lists(), fn(child) ->
      Tips.Todo.List.name(child) == {name}
    end
  end

  @doc """
  ## Example:

      iex> Server.add_list("find-by-name")
      {:ok, pid}
      iex> pid = Server.find_list("find-by-name")
      pid
      iex> Server.delete_list(pid)
      :ok
      iex> Server.delete_list(pid)
      {:error, :not_found}
  """
  @spec delete_list(pid()) :: :ok | {:error, :not_found} | :ignore
  def delete_list(list) do
    try do
      DynamicSupervisor.terminate_child(Server, list)
    rescue
      FunctionClauseError -> :ignore
    end
  end

  @doc """
  ## Example:

      iex> Server.add_list("find-by-name")
      {:ok, pid}
      iex> Server.lists
      [pid]
      iex> pid = Server.find_list("find-by-name")
      pid
      iex> Server.delete_list(pid)
      :ok
      iex> Server.lists
      []
  """
  @spec lists() :: [pid()] | []
  def lists do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
  end

  @doc """
  ## Example:

      iex> Server.children
      []
  """
  @spec children() :: [{:undefined, pid, :worker, [Tips.Todo.List]}] | []
  def children do
    DynamicSupervisor.which_children(Server)
  end

  @doc """
  ## Example:

      iex> Server.count_children
      %{active: 0, specs: 0, supervisors: 0, workers: 0}
  """
  @spec count_children() :: %{active: integer, specs: integer, supervisors: integer, workers: integer}
  def count_children do
    DynamicSupervisor.count_children(Server)
  end

  @impl true
  @spec init(init_arg :: term()) :: {:ok, {:supervisor.sup_flags(), [:supervisor.child_spec()]}} | :ignore
  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [])
  end
end
