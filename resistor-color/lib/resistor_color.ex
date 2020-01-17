defmodule ResistorColor do
  @moduledoc false

  @colors %{
    "black" => 0,
    "brown" => 1,
    "red" => 2,
    "orange" => 3,
    "yellow" => 4,
    "green" => 5,
    "blue" => 6,
    "violet" => 7,
    "grey" => 8,
    "white" => 9
  }

  @spec colors() :: list(String.t())
  def colors do
    color_list = Map.to_list(@colors)
    Map
  end

  @spec code(String.t()) :: integer()
  def code(color) do
    Map.fetch!(@colors, color)
  end
end
