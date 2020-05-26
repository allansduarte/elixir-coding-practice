defmodule Grains do
  @board_range 1..64

  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number in @board_range, do: {:ok, round(:math.pow(2, number - 1))}

  def square(_number), do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    {:ok, do_total()}
  end

  defp do_total do
    @board_range
    |> Stream.map(&square/1)
    |> Stream.map(fn {:ok, square} -> square end)
    |> Enum.sum()
  end
end
