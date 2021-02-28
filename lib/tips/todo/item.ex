defmodule Tips.Todo.Item do
  @moduledoc false

  alias __MODULE__, as: Item

  defstruct id: nil, description: nil, completed: false

  @doc """
  ## Example:

      iex> Tips.Todo.Item.new("Hello world")
      %Tips.Todo.Item{completed: false, description: "Hello world", id: 553827456}
  """
  @spec new(String.t()) :: %Item{id: integer, description: String.t()}
  def new(description) when is_bitstring(description) do
    %Item{id: :rand.uniform(1_000_000_000), description: description}
  end

  @spec new(any) :: {:error, message: String.t()}
  def new(_), do: {:error, message: "Argument is not correct!"}
end
