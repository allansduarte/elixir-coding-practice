defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(_digits, base_a, base_b) when base_a < 2 or base_b < 2, do: nil
  def convert([], _, _), do: nil

  def convert(digits, base_a, base_b) do
    digits
    |> to_integer(base_a)
    |> to_digits(base_b)
  end

  defp to_integer(digits, base, acc \\ 0)
  defp to_integer([], _, acc), do: acc
  defp to_integer([d | _], _, _) when d < 0, do: nil
  defp to_integer([d | _], base, _) when d >= base, do: nil

  defp to_integer([d | ds], base, acc) do
    to_integer(ds, base, acc * base + d)
  end

  defp to_digits(integer, base, acc \\ [])
  defp to_digits(nil, _, _), do: nil
  defp to_digits(0, _, []), do: [0]
  defp to_digits(0, _, acc), do: acc

  defp to_digits(integer, base, acc) do
    to_digits(div(integer, base), base, [rem(integer, base) | acc])
  end
end
