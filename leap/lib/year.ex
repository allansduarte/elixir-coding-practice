defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      unless the year is also evenly divisible by 400
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do
    case remainder_matrix(year) do
      {0, 0, 0} -> true
      {0, 0, _} -> false
      {0, _, _} -> true
      _ -> false
    end
  end

  defp remainder_matrix(year) do
    {rem(year, 4), rem(year, 100), rem(year, 400)}
  end
end
