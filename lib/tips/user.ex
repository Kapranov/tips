defmodule Tips.User do
  @moduledoc """
  Defines the user struct and functions to handle users.
  """

  import String, only: [split: 1]
  import List, only: [first: 1, last: 1]

  defstruct name: nil

  @doc """
  Get the first name of a user

  ## Parameters

  - `user` - A User struct

  ## Examples

      iex> user = %Tips.User{ name: "Edward Witten" }
      iex> Tips.User.first_name(user)
      "Edward"

      iex> Tips.User.first_name(nil)
      {:error, "Please created struct"}

      iex> Tips.User.first_name(%{})
      {:error, "A name not found in Tips.User"}
  """
  @spec first_name(map) :: String.t()
  def first_name(user) when is_map(user) do
    try do
      user
      |> get_names
      |> first
    rescue
      KeyError -> {:error, "A name not found in Tips.User"}
    end
  end

  @spec first_name(any) :: {:error, String.t()}
  def first_name(_), do: {:error, "Please created struct"}

  @doc """
  Get the last name of a user

  ## Parameters

  - `user` - A User struct

  ## Examples

      iex> user = %Tips.User{ name: "Edward Witten" }
      iex> Tips.User.last_name(user)
      "Witten"

      iex> Tips.User.first_name(nil)
      {:error, "Please created struct"}

      iex> Tips.User.first_name(%{})
      {:error, "A name not found in Tips.User"}
  """
  @spec last_name(map) :: String.t()
  def last_name(user) when is_map(user) do
    try do
      user
      |> get_names
      |> last
    rescue
      KeyError -> {:error, "A name not found in Tips.User"}
    end
  end

  @spec last_name(any) :: {:error, String.t()}
  def last_name(_), do: {:error, "Please created struct"}

  @spec get_names(String.t()) :: String.t()
  defp get_names(user), do: split(user.name)
end
