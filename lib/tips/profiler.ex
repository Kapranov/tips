defmodule Tips.Profiler do
  @moduledoc """
  Simple benchmark helper which relies on `:timer.tc/1`
  """

  @spec run(atom, integer, integer) :: String.t()
  def run(module, operations_count, concurrency_level \\ 1) do
    IO.puts("")
    module.start_link

    time =
      execution_time(
        fn -> module.cached(:index, &Tips.WebServer.index/0) end,
        operations_count,
        concurrency_level
      )

    projected_rate = round(1_000_000 * operations_count * concurrency_level / time)
    IO.puts("#{projected_rate} reqs/sec\n")
  end

  @doc """
  We measure the execution time of the entire operation
  """
  @spec execution_time(fun, integer, integer) :: integer
  def execution_time(fun, operations_count, concurrency_level) do
    {time, _} =
      :timer.tc(fn ->
        me = self()

        for _ <- 1..concurrency_level do
          spawn(fn ->
            for _ <- 1..operations_count, do: fun.()
            send(me, :computed)
          end)
        end

        for _ <- 1..concurrency_level do
          receive do
            :computed -> :ok
          end
        end
      end)

    time
  end
end
