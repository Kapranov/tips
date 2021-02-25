defmodule Tips.TodoItem do
  @moduledoc false

  @enforce_keys [:name]
  defstruct [:name, :description]
end
