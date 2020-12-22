defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1), do: []

  def factors_for(number) when rem(number, 2) == 0, do: [2] ++ factors_for(div(number, 2))

  def factors_for(number) do
    factor =
      3..(number |> :math.sqrt() |> floor())
      |> Enum.find(number, &(rem(number, &1) == 0))

    [factor] ++ factors_for(div(number, factor))
  end
end
