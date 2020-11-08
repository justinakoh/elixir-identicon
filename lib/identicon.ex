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
    |> pick_colour
  end

  @doc """
    This gets the first three values from the hexlist to get a RGB colour.
    This pattern matching on the struct to get the first three values
  """
  def pick_colour(%Identicon.Image{hex: [r, g, b | _tail]} = image) do

    #The parameter is the same as the commented code belo. You can pattern match as you receive the argument
    #%Identicon.Image{hex: [r, g, b | _tail]} = image

    #This gets the first three values, and acknowledges the rest of the values
    #but we don't actualyl care about it. It is the same as the commented code below
    #[r, g, b | _tail] = hex_list

    #'Updating' struct property
    %Identicon.Image{image | colour: {r, g, b}}
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
