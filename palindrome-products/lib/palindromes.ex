defmodule Palindromes do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    products(min_factor, max_factor)
    |> Enum.filter(&palindrome?/1)
    |> Enum.map(fn product ->
      {product,
       product
       |> factors()
       |> Enum.filter(fn factors ->
         Enum.all?(factors, &(&1 in min_factor..max_factor))
       end)}
    end)
    |> Enum.into(%{})
  end

  defp products(min_factor, max_factor) do
    min_factor..max_factor
    |> Enum.map(fn left -> Enum.map(min_factor..max_factor, &(left * &1)) end)
    |> Enum.concat()
  end

  defp palindrome?(number) do
    number
    |> Integer.digits()
    |> Enum.reverse() == Integer.digits(number)
  end

  defp factors(number) do
    Range.new(1, number |> :math.sqrt() |> round())
    |> Enum.filter(&(rem(number, &1) == 0))
    |> Enum.map(&[&1, div(number, &1)])
  end
end
