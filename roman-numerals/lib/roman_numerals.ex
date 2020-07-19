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
    to_roman(number, @numerals)
  end

  defp to_roman(0, _), do: ""
  defp to_roman(number, [{letter, digit} | _tail] = num_list) when number >= digit,
    do: to_string(letter) <> to_roman(number - digit, num_list)
  defp to_roman(number, [{_letter, digit} | tail]) when number < digit, do: to_roman(number, tail)
end
