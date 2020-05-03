defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..(limit - 1)
    |> Enum.filter(prime?(factors))
    |> Enum.sum()
  end

  defp prime?(factors) do
    fn
      number ->
        Enum.filter(factors, fn prime_factor ->
          rem(number, prime_factor) == 0
        end) != []
    end
  end
end
