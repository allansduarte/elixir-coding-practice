defmodule Raindrops do
  @drops [Pling: 3, Plang: 5, Plong: 7]

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    @drops
    |> parse(number)
    |> do_convert(number)
  end

  defp parse(drops, number), do: Enum.filter(drops, &divisible_factors?(&1, number))
  defp divisible_factors?({_value, prime_factor}, number), do: rem(number, prime_factor) == 0

  defp do_convert([], number), do: "#{number}"

  defp do_convert(drops_result, _number),
    do: Enum.map_join(drops_result, "", fn {key, _value} -> "#{key}" end)
end
