defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(n) when n <= 0,
    do: {:error, "Classification is only possible for natural numbers."}

  def classify(n) when n <= 2, do: {:ok, :deficient}

  def classify(number) do
    number
    |> factors()
    |> Enum.sum()
    |> Kernel.+(1)
    |> compare(number)
  end

  defp factors(n) do
    2..middle(n)
    |> Enum.filter(&(rem(n, &1) == 0))
    |> Enum.map(&[&1, div(n, &1)])
    |> Enum.concat()
    |> Enum.uniq()
  end

  defp middle(n), do: n |> :math.sqrt() |> floor()

  defp compare(n, n), do: {:ok, :perfect}
  defp compare(m, n) when m > n, do: {:ok, :abundant}
  defp compare(_, _), do: {:ok, :deficient}
end
