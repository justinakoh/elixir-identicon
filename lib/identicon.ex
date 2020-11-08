defmodule Identicon do
  @moduledoc """
    `Identicon` is an app which receives a string and creates an identicon based off of the string.
  """

  @doc """
    Main. Pretty basic stuff
  """
  def main(input) do
    input
    |> hash_input
  end

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
