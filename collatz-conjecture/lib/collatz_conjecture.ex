defmodule CollatzConjecture do
  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(input :: pos_integer()) :: non_neg_integer()
  def calc(input) when is_number(input) and input == 1, do: 0
  def calc(input) when is_number(input) and input > 1, do: do_calc(input, 0)

  defp do_calc(input, steps) when input > 1 do
    result =
      cond do
        odd?(input) ->
          input * 3 + 1

        even?(input) ->
          trunc(input / 2)
      end

    do_calc(result, 1 + steps)
  end

  defp do_calc(1, steps), do: steps

  defp even?(number), do: rem(number, 2) == 0
  defp odd?(number), do: rem(number, 2) != 0
end
