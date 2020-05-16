defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise "must be greater than zero"
  def nth(count) do
    2..10_000
    |> Stream.filter(&is_prime(&1))
    |> Enum.take(count)
    |> (fn l -> List.last(l) end).()
  end

  @spec is_prime(non_neg_integer) :: boolean
  defp is_prime(num) do
    case Enum.filter(2..num, fn x -> rem(num, x) == 0 end) do
      [_num] -> true
        _   -> false
    end
  end
end
