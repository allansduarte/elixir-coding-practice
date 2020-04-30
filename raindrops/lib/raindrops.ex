defmodule Raindrops do
  @drops %{3 => "Pling", 5 => "Plang", 7 => "Plong"}

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
    number
    |> is_prime?()
    |> :maps.filter(@drops)
    |> do_convert(number)
  end

  defp is_prime?(number) do
    fn
      prime_factor, _value -> rem(number, prime_factor) == 0
    end
  end

  defp do_convert(drops_result, number) when drops_result == %{} , do: "#{number}"
  defp do_convert(drops_result, _), do: Enum.map_join(drops_result, "", fn {_key, value} -> "#{value}" end)
end
