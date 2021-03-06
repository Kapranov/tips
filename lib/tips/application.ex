defmodule Tips.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Tips.TodoSupervisor,
      {Tips.Todo.Cache, []},
      {DynamicSupervisor, strategy: :one_for_one, name: Tips.Todo.Server}
    ]

    opts = [strategy: :one_for_one, name: Tips.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
