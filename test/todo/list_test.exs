defmodule Tips.Todo.ListTest do
  use ExUnit.Case

  alias Tips.Todo.{List, Item, Cache}

  setup do
    {:ok, list} = List.start_link("Home")

    on_exit fn ->
      Cache.clear
    end

    {:ok, list: list}
  end

  test "#items returns the todos on the list", %{list: list} do
    assert List.items(list) == []
  end

  test "#add adds an item to the list", %{list: list} do
    item = Item.new("Create an OTP app")
    List.add(list, item)
    assert List.items(list) == [item]
  end

  test "#update can mark an item complete", %{list: list} do
    item = Item.new("Completing a task")
    List.add(list, item)
    updated_item = %{item | description: "new", completed: true}
    List.update(list, updated_item)
    assert List.items(list) == [updated_item]
  end
end
