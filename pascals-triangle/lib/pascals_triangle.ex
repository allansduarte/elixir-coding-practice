defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    rows(num, [[1]])
  end

  defp rows(1, result), do: Enum.reverse(result)

  defp rows(num, [first | rest]) do
    new = next_row(first, [1])
    rows(num - 1, [new, first | rest])
  end

  defp next_row([value], result), do: [value | result]

  defp next_row([first, second | rest], result) do
    next_row([second | rest], [first + second | result])
  end
end
