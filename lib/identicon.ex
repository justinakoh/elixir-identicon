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

  @doc """
    This creates a hash off the input passed in
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end


end
