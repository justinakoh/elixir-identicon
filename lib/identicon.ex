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
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{colour: colour, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(colour)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end


  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end

      %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    #This will return true if is divisble by zero, else return true
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0 #calculates remainder
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)  #stuffs every row into a new list map thing
      |> List.flatten             #Takes a nested list and makes it into one list
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row

    #This mirrors the row. ++ is how we append a two lists
    row ++ [second, first]
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
