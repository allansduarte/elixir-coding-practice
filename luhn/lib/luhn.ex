defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    case Regex.match?(~r/^[\d ]{2,}$/, number) do
      true ->
        number
        |> get_digits()
        |> digits_valid?()

      _ ->
        false
    end
  end

  defp get_digits(number) do
    [h | t] =
      number
      |> String.replace(" ", "")
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)

    case h do
      0 -> t
      _ -> [h | t]
    end
  end

  defp digits_valid?(digits) when length(digits) > 1 do
    sum =
      digits
      |> Enum.map_every(2, &double_and_subtract/1)
      |> Enum.sum()

    rem(sum, 10) == 0
  end

  defp digits_valid?(digits), do: false

  defp double_and_subtract(n) do
    d = n * 2

    cond do
      d > 9 -> d - 9
      true -> d
    end
  end
end
