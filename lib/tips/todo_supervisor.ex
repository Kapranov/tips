defmodule Tips.TodoSupervisor do
  use Supervisor

  @name __MODULE__

  def start_link([]) do
    Supervisor.start_link(@name, [], name: @name)
  end

  def init([]) do
    children = [
      %{
        id: Tips.TodoList,
        start: {Tips.TodoList, :start_link, [[]]},
        restart: :transient
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
