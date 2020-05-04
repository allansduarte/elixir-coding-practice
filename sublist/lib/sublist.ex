defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, a), do: :equal

  def compare(a, b) do
    cond do
      sublist?(a, b) -> :sublist
      sublist?(b, a) -> :superlist
      true -> :unequal
    end
  end

  defp sublist?(_, []), do: false

  defp sublist?(a, b = [_ | b_tail]) do
    matches?(a, b) || sublist?(a, b_tail)
  end

  defp matches?([], _), do: true

  defp matches?([matching_value | a], [matching_value | b]) do
    matches?(a, b)
  end

  defp matches?(_, _), do: false
end
