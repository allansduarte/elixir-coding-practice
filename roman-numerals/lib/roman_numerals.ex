defmodule RomanNumerals do
  @numerals [
    M: 1000,
    CM: 900,
    D: 500,
    CD: 400,
    C: 100,
    XC: 90,
    L: 50,
    XL: 40,
    X: 10,
    IX: 9,
    V: 5,
    IV: 4,
    I: 1
  ]

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    do_numeral([], number, @numerals)
  end

  defp do_numeral(curr_nums, number, [{letter, digit} | _tail] = num_list) when number >= digit do
    do_numeral([letter | curr_nums], number - digit, num_list)
  end

  defp do_numeral(curr_nums, number, [_head | tail]) do
    do_numeral(curr_nums, number, tail)
  end

  defp do_numeral(numerals, _number, []) do
    numerals
    |> Enum.reverse()
    |> Enum.map_join("", &to_string/1)
  end
end
